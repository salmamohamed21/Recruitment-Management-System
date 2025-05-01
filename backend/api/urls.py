from django.conf import settings
from django.conf.urls.static import static

from django.urls import path, include
from .views import get_recruiter_images
from rest_framework.routers import DefaultRouter
from .views import (
    home, register_user, login_user, logout_user, apply_for_job, upload_and_analyze_cv, 
    suggest_job_seekers, create_job, DeleteJobView, ViewJobApplicantsView, save_job_preferences,
    view_posted_jobs, view_job_details, accept_job_seeker, change_password, 
    update_recruiter_profile, update_job_seeker_profile, public_hot_jobs,
    get_jobseeker_details , get_jobseeker_by_email, get_jobseeker_overview_sections ,
    jobseeker_job_page_details, job_and_company_details , get_accepted_jobs_for_jobseeker , get_suggested_jobs_for_jobseeker
    , reject_suggested_job, search_jobs , get_jobseeker_profile_image
)

# إعداد الـ Router (اختياري إذا كنتِ تستخدمين ViewSets في المستقبل)
router = DefaultRouter()
# router.register(r'jobs', JobViewSet)
# router.register(r'applications', JobApplicationViewSet)

# تعريف المسارات بناءً على النقاط الطرفية المستخدمة في الـ Frontend
urlpatterns = [
    # الصفحة الرئيسية
    path('', home, name='home'),

    # تسجيل المستخدم وتسجيل الدخول والخروج
    path('register/', register_user, name='register_user'),
   # path('login/', login_user, name='login_user'),
    path('login_user/', login_user, name='login_user'),  # Added alias for login_user endpoint
    path('logout_user/', logout_user, name='logout_user'),

    # إدارة الملف الشخصي
    path('recruiter/profile/update/', update_recruiter_profile, name='update_recruiter_profile'),  # لتحديث ملف الـ Recruiter
    path('jobseeker/profile/update/', update_job_seeker_profile, name='update_job_seeker_profile'),  # لتحديث ملف الـ Job Seeker
    path('change-password/', change_password, name='change_password'),  # لتغيير كلمة المرور

    # رفع وتحليل السيرة الذاتية (ATS)
    path('uploads/', upload_and_analyze_cv, name='upload_cv'),  # مستخدم في `AtsResult.js`

    path('preferences/', save_job_preferences, name='save_preferences'),
    # إنشاء وظيفة جديدة (للـ Recruiter)
    path('create-job/', create_job, name='create_job'),  # مستخدم في `PostNewJob.js`

    # التقديم على وظيفة (للـ Job Seeker)
    path('apply-job/<int:job_id>/', apply_for_job, name='apply_for_job'),  # مستخدم في الـ Frontend

    # عرض الوظائف المنشورة (للـ Employer)
    path('employer/view-posted-jobs/', view_posted_jobs, name='view_posted_jobs'),  # مستخدم في `ViewPostedJobs.js`

    # عرض تفاصيل الوظيفة مع الاقتراحات (للـ Employer)
    path('employer/view-job-details/<int:job_id>/', view_job_details, name='view_job_details'),  # جديد لعرض تفاصيل الوظيفة

    # حذف وظيفة (للـ Employer)
    path('employer/delete-job/<int:id>/', DeleteJobView.as_view(), name='delete_job'),  # مستخدم في `ViewPostedJobs.js`

    # عرض المتقدمين للوظائف (للـ Employer)
    path('employer/view-job-applicants/', ViewJobApplicantsView.as_view(), name='view_job_applicants'),  # مستخدم في `ViewJobApplicants.js`

    # عرض المتقدمين بناءً على ML (للـ Employer)
    path('employer/view-ml-applicants/<int:job_id>/', ViewJobApplicantsView.as_view(), name='view_ml_applicants'),  # مستخدم في `ViewJobApplicants.js`

    # اقتراح الـ Job Seekers للوظيفة (للـ Employer)
    path('employer/job-suggestions/<int:job_id>/', suggest_job_seekers, name='suggest_job_seekers'),  # مستخدم في `ViewSuggestions.js`

    # قبول الـ Job Seeker (للـ Employer)
    path('employer/accept-jobseeker/<int:application_id>/', accept_job_seeker, name='accept_job_seeker'),  # جديد لقبول Job Seeker

    # عرض تفاصيل Job Seeker
    path('jobseeker/details/<int:jobseeker_id>/', get_jobseeker_details, name='get_jobseeker_details'),
    path('jobseeker/overview_sections/<int:jobseeker_id>/', get_jobseeker_overview_sections, name='get_jobseeker_overview_sections'),

    # Public API for hot jobs
    path('public/hot-jobs/', public_hot_jobs, name='public_hot_jobs'),

    # New endpoint to get jobseeker by email
    path('job_seekers/', get_jobseeker_by_email, name='get_jobseeker_by_email'),

    # Jobseeker job page details endpoint
    path('jobseeker/job/<int:job_id>/', jobseeker_job_page_details, name='jobseeker_job_page_details'),
    path('jobseeker/job-company-details/<int:job_id>/', job_and_company_details, name='job_and_company_details'),

    # Added endpoints for suggested and accepted jobs for job seekers
    path('suggested-jobs/', get_suggested_jobs_for_jobseeker, name='get_suggested_jobs_for_jobseeker'),
    path('accepted-jobs/', get_accepted_jobs_for_jobseeker, name='get_accepted_jobs_for_jobseeker'),
    path('reject-suggested-job/', reject_suggested_job, name='reject_suggested_job'),

    # New endpoint to get jobseeker profile image URL
    path('jobseeker/profile/image/', get_jobseeker_profile_image, name='get_jobseeker_profile_image'),

    # New endpoint to get recruiter images (logo and cover)
    path('recruiter/images/', get_recruiter_images, name='get_recruiter_images'),

    # تضمين أي مسارات إضافية من الـ Router (اختياري)
    path('search/', search_jobs, name='search_jobs'),
    path('search', search_jobs, name='search_jobs_no_slash'),
    path('', include(router.urls)),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
