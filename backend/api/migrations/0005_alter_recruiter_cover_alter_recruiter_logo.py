# Generated by Django 5.0.14 on 2025-04-28 21:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_jobseeker_profile_image'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recruiter',
            name='cover',
            field=models.ImageField(blank=True, null=True, upload_to='images/'),
        ),
        migrations.AlterField(
            model_name='recruiter',
            name='logo',
            field=models.ImageField(blank=True, null=True, upload_to='images/'),
        ),
    ]
