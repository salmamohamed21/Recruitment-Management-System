# Generated by Django 5.0.14 on 2025-04-22 11:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_jobseeker_experience_level'),
    ]

    operations = [
        migrations.AddField(
            model_name='recruiter',
            name='cover',
            field=models.ImageField(blank=True, null=True, upload_to='recruiter_covers/'),
        ),
        migrations.AddField(
            model_name='recruiter',
            name='logo',
            field=models.ImageField(blank=True, null=True, upload_to='recruiter_logos/'),
        ),
    ]
