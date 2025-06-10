from django.db import models
from django.utils import timezone
from datetime import timedelta
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    USER_TYPE_CHOICES = (
        ('recruiter', 'Recruiter'),
        ('job_seeker', 'Job Seeker'),
    )
    user_type = models.CharField(max_length=20, choices=USER_TYPE_CHOICES)
    email = models.EmailField(unique=True, max_length=254)
    country = models.CharField(max_length=100, blank=True, null=True)
    phone = models.CharField(max_length=20, blank=True, null=True)
    full_name = models.CharField(max_length=255, blank=True)

class Recruiter(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    company_name = models.CharField(max_length=255)
    company_description = models.TextField(blank=True, null=True)
    logo = models.ImageField(upload_to='images/', blank=True, null=True)
    cover = models.ImageField(upload_to='images/', blank=True, null=True)

class JobSeeker(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    full_name = models.CharField(max_length=255, blank=True, null=True)
    work_mode = models.CharField(max_length=50, blank=True, null=True)
    preferred_job_type = models.CharField(max_length=50, blank=True, null=True)
    preferred_location = models.CharField(max_length=100, blank=True, null=True)
    salary_expectation = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    experience_level = models.CharField(max_length=50, blank=True, null=True)
    overview = models.TextField(blank=True, null=True)
    classification = models.CharField(max_length=255, blank=True, null=True)
    score = models.FloatField(blank=True, null=True)
    profile_image = models.ImageField(upload_to='jobseeker_images/', blank=True, null=True)

class Job(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    expiry_date = models.DateField(blank=True, null=True)
    category = models.CharField(max_length=100, blank=True, null=True)
    location = models.CharField(max_length=100, blank=True, null=True)
    type = models.CharField(max_length=50, blank=True, null=True)
    level = models.CharField(max_length=50, blank=True, null=True)
    experience = models.CharField(max_length=50, blank=True, null=True)
    qualification = models.CharField(max_length=100, blank=True, null=True)
    salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    recruiter = models.ForeignKey(Recruiter, on_delete=models.CASCADE)

class Application(models.Model):
    job = models.ForeignKey(Job, on_delete=models.CASCADE)
    jobseeker = models.ForeignKey(JobSeeker, on_delete=models.CASCADE)
    match_score = models.FloatField(blank=True, null=True)
    is_suggestion = models.BooleanField(default=False)
    state = models.CharField(max_length=50, default='pending')

class OTPVerification(models.Model):
    user = models.ForeignKey('User', on_delete=models.CASCADE)
    otp_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()

    def is_expired(self):
        return timezone.now() > self.expires_at

    def save(self, *args, **kwargs):
        if not self.expires_at:
            self.expires_at = timezone.now() + timedelta(minutes=10)  # OTP valid for 10 minutes
        super().save(*args, **kwargs)
