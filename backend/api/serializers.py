from rest_framework import serializers
from .models import User, Job, Application, Recruiter, JobSeeker
from django.contrib.auth.hashers import make_password

# Serializer لنموذج User
class UserSerializer(serializers.ModelSerializer):
    company_name = serializers.CharField(write_only=True, required=False, allow_blank=True)
    company_description = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'password', 'email', 'full_name',
                  'user_type', 'country', 'phone', 'company_name', 'company_description']

    def validate_username(self, value):
        user_qs = User.objects.filter(username=value)
        if self.instance:
            user_qs = user_qs.exclude(pk=self.instance.pk)
        if user_qs.exists():
            raise serializers.ValidationError("A user with this username already exists.")
        return value

    def validate_email(self, value):
        user_qs = User.objects.filter(email=value)
        if self.instance:
            user_qs = user_qs.exclude(pk=self.instance.pk)
        if user_qs.exists():
            raise serializers.ValidationError("A user with this email already exists.")
        return value

    def create(self, validated_data):
        company_name = validated_data.pop('company_name', None)
        company_description = validated_data.pop('company_description', None)
        validated_data['password'] = make_password(validated_data.get('password'))
        user = super().create(validated_data)
        
        if company_name and user.user_type == 'recruiter':
            Recruiter.objects.create(
                user=user,
                company_name=company_name,
                company_description=company_description or ''
            )
        return user

# Serializer لنموذج JobSeeker
class JobSeekerSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='user.full_name')
    email = serializers.CharField(source='user.email')
    phone = serializers.CharField(source='user.phone')  # Added phone field
    country = serializers.CharField(source='user.country')  # Added country field
    jobs = serializers.SerializerMethodField()
    work_mode = serializers.CharField()
    preferred_job_type = serializers.CharField()
    preferred_location = serializers.CharField()
    salary_expectation = serializers.DecimalField(max_digits=10, decimal_places=2)
    experience_level = serializers.CharField()
    score = serializers.FloatField()
    overview = serializers.CharField()  # إضافة حقل overview
    classification = serializers.CharField()  # إضافة حقل classification
    profile_image = serializers.SerializerMethodField()
    profile_image_file = serializers.ImageField(source='profile_image', required=False, allow_null=True)

    class Meta:
        model = JobSeeker
        fields = ['full_name', 'email', 'phone', 'country', 'jobs', 'work_mode', 'preferred_job_type', 'experience_level',
                  'preferred_location', 'salary_expectation', 'score', 'overview', 'classification', 'profile_image']

    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', {})
        user = instance.user

        # Update User fields
        for attr, value in user_data.items():
            setattr(user, attr, value)
        user.save()

        # Update JobSeeker fields
        profile_image_data = validated_data.pop('profile_image_file', None)
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        if profile_image_data is not None:
            instance.profile_image = profile_image_data
        instance.save()

        return instance

    class Meta:
        model = JobSeeker
        fields = ['full_name', 'email', 'phone', 'country', 'jobs', 'work_mode', 'preferred_job_type', 'experience_level',
                  'preferred_location', 'salary_expectation', 'score', 'overview', 'classification', 'profile_image', 'profile_image_file']

    def get_jobs(self, obj):
        applications = obj.application_set.all()
        return [{
            "title": app.job.title,
            "match_score": app.match_score
        } for app in applications]

    def get_profile_image(self, obj):
        request = self.context.get('request')
        profile_image = obj.profile_image
        if profile_image and hasattr(profile_image, 'url'):
            url = profile_image.url
            if request is not None:
                return request.build_absolute_uri(url)
            return url
        return None

    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', {})
        user = instance.user

        # Update User fields
        for attr, value in user_data.items():
            setattr(user, attr, value)
        user.save()

        # Update JobSeeker fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        return instance

# Serializer لنموذج Recruiter (nested in JobSerializer)
class RecruiterNestedSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source='company_name')
    address = serializers.CharField(source='user.country')
    logo = serializers.SerializerMethodField()

    class Meta:
        model = Recruiter
        fields = ['name', 'address', 'logo']

    def get_logo(self, obj):
        request = self.context.get('request')
        if obj.logo and hasattr(obj.logo, 'url'):
            logo_url = obj.logo.url
            if request is not None:
                return request.build_absolute_uri(logo_url)
            return logo_url
        return ""

# Serializer لنموذج Job
class JobSerializer(serializers.ModelSerializer):
    recruiter = RecruiterNestedSerializer(read_only=True)
    slug = serializers.CharField(read_only=True)
    deadline = serializers.DateField(source='expiry_date', read_only=True)

    class Meta:
        model = Job
        fields = ['id', 'title', 'description', 'expiry_date', 'deadline', 'category', 
                  'location', 'type', 'level', 'experience', 'qualification', 'salary', 'recruiter', 'slug']

# Serializer لنموذج Application (JobApplicationSerializer)
class JobApplicationSerializer(serializers.ModelSerializer):
    job = JobSerializer(read_only=True)
    jobseeker_name = serializers.CharField(source='jobseeker.user.full_name', read_only=True)
    jobseeker_email = serializers.CharField(source='jobseeker.user.email', read_only=True)
    overview = serializers.CharField(source='jobseeker.overview', read_only=True)  # إضافة حقل overview
    
    class Meta:
        model = Application
        fields = ['id', 'job', 'jobseeker', 'jobseeker_name', 'jobseeker_email',
                  'match_score', 'state', 'is_suggestion', 'overview']
        extra_kwargs = {
            'match_score': {'read_only': True}
        }

# Serializer لنموذج Application (JobSuggestionSerializer)
class JobSuggestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Application
        fields = ['id', 'job', 'jobseeker', 'state', 'is_suggestion']
        read_only_fields = ['is_suggestion']

# Serializer لنموذج Recruiter
class RecruiterSerializer(serializers.ModelSerializer):
    logo = serializers.ImageField(required=False, allow_null=True)
    cover = serializers.ImageField(required=False, allow_null=True)
    logo_url = serializers.SerializerMethodField()
    cover_url = serializers.SerializerMethodField()

    class Meta:
        model = Recruiter
        fields = ['company_name', 'company_description', 'logo', 'cover', 'logo_url', 'cover_url']

    def get_logo_url(self, obj):
        request = self.context.get('request')
        if obj.logo and hasattr(obj.logo, 'url'):
            logo_url = obj.logo.url
            if request is not None:
                return request.build_absolute_uri(logo_url)
            return logo_url
        return ""

    def get_cover_url(self, obj):
        request = self.context.get('request')
        if obj.cover and hasattr(obj.cover, 'url'):
            cover_url = obj.cover.url
            if request is not None:
                return request.build_absolute_uri(cover_url)
            return cover_url
        return ""

