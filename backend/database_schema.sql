USE [job_back]
GO
/****** Object:  User [user_back]    Script Date: 01/05/2025 03:30:40 ص ******/
CREATE USER [user_back] FOR LOGIN [user_back] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [user_back]
GO
/****** Object:  Table [dbo].[api_application]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_application](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[match_score] [float] NULL,
	[is_suggestion] [bit] NOT NULL,
	[state] [nvarchar](50) NOT NULL,
	[job_id] [bigint] NOT NULL,
	[jobseeker_id] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[api_job]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_job](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NOT NULL,
	[expiry_date] [date] NULL,
	[category] [nvarchar](100) NULL,
	[location] [nvarchar](100) NULL,
	[type] [nvarchar](50) NULL,
	[level] [nvarchar](50) NULL,
	[experience] [nvarchar](50) NULL,
	[qualification] [nvarchar](100) NULL,
	[salary] [numeric](10, 2) NULL,
	[recruiter_id] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[api_jobseeker]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_jobseeker](
	[user_id] [bigint] NOT NULL,
	[full_name] [nvarchar](255) NULL,
	[work_mode] [nvarchar](50) NULL,
	[preferred_job_type] [nvarchar](50) NULL,
	[preferred_location] [nvarchar](100) NULL,
	[salary_expectation] [numeric](10, 2) NULL,
	[overview] [nvarchar](max) NULL,
	[classification] [nvarchar](255) NULL,
	[score] [float] NULL,
	[experience_level] [nvarchar](50) NULL,
	[profile_image] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[api_recruiter]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_recruiter](
	[user_id] [bigint] NOT NULL,
	[company_name] [nvarchar](255) NOT NULL,
	[company_description] [nvarchar](max) NULL,
	[cover] [nvarchar](100) NULL,
	[logo] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[api_user]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_user](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[last_login] [datetime2](7) NULL,
	[username] [nvarchar](150) NOT NULL,
	[date_joined] [datetime2](7) NOT NULL,
	[user_type] [nvarchar](20) NOT NULL,
	[email] [nvarchar](254) NOT NULL,
	[country] [nvarchar](100) NULL,
	[phone] [nvarchar](20) NULL,
	[is_superuser] [bit] NOT NULL DEFAULT ((0)),
	[is_staff] [bit] NOT NULL DEFAULT ((0)),
	[is_active] [bit] NOT NULL DEFAULT ((1)),
	[full_name] [nvarchar](255) NOT NULL DEFAULT (''),
	[first_name] [nvarchar](150) NOT NULL DEFAULT (''),
	[last_name] [nvarchar](150) NOT NULL DEFAULT (''),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[api_user_groups]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_user_groups](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[group_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[api_user_user_permissions]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_user_user_permissions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[auth_group]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[auth_group_permissions]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group_permissions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[group_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[auth_permission]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[content_type_id] [int] NOT NULL,
	[codename] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[authtoken_token]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[authtoken_token](
	[key] [nvarchar](40) NOT NULL,
	[created] [datetime2](7) NOT NULL,
	[user_id] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[django_admin_log]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_admin_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[action_time] [datetime2](7) NOT NULL,
	[object_id] [nvarchar](max) NULL,
	[object_repr] [nvarchar](200) NOT NULL,
	[action_flag] [smallint] NOT NULL,
	[change_message] [nvarchar](max) NOT NULL,
	[content_type_id] [int] NULL,
	[user_id] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[django_content_type]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_content_type](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[app_label] [nvarchar](100) NOT NULL,
	[model] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[django_migrations]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_migrations](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[app] [nvarchar](255) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[applied] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[django_session]    Script Date: 01/05/2025 03:30:40 ص ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_session](
	[session_key] [nvarchar](40) NOT NULL,
	[session_data] [nvarchar](max) NOT NULL,
	[expire_date] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[session_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[api_application] ON 

INSERT [dbo].[api_application] ([id], [match_score], [is_suggestion], [state], [job_id], [jobseeker_id]) VALUES (1, 95, 1, N'accepted', 8, 6)
INSERT [dbo].[api_application] ([id], [match_score], [is_suggestion], [state], [job_id], [jobseeker_id]) VALUES (2, 95, 1, N'accepted', 10, 6)
INSERT [dbo].[api_application] ([id], [match_score], [is_suggestion], [state], [job_id], [jobseeker_id]) VALUES (20, 90, 1, N'accepted', 17, 9)
INSERT [dbo].[api_application] ([id], [match_score], [is_suggestion], [state], [job_id], [jobseeker_id]) VALUES (21, 85, 1, N'suggested', 17, 11)
INSERT [dbo].[api_application] ([id], [match_score], [is_suggestion], [state], [job_id], [jobseeker_id]) VALUES (22, 85, 1, N'suggested', 17, 13)
INSERT [dbo].[api_application] ([id], [match_score], [is_suggestion], [state], [job_id], [jobseeker_id]) VALUES (23, 90, 1, N'accepted', 18, 10)
INSERT [dbo].[api_application] ([id], [match_score], [is_suggestion], [state], [job_id], [jobseeker_id]) VALUES (24, 85, 1, N'accepted', 18, 12)
INSERT [dbo].[api_application] ([id], [match_score], [is_suggestion], [state], [job_id], [jobseeker_id]) VALUES (26, 75, 1, N'suggested', 18, 16)
SET IDENTITY_INSERT [dbo].[api_application] OFF
SET IDENTITY_INSERT [dbo].[api_job] ON 

INSERT [dbo].[api_job] ([id], [title], [description], [expiry_date], [category], [location], [type], [level], [experience], [qualification], [salary], [recruiter_id]) VALUES (4, N'Machine Learning Engineer', N'<p>TripleByte Certified Engineer Candidate Profile Introduction , is a data scientist with over two years of experience in machine learning, specializing in predictive, descriptive, and prescriptive analysis. Her key strengths lie in model deployment, database management, and delivering actionable insights using a strong data-driven approach. She holds a TripleByte Engineer certification, demonstrating high technical proficiency. Education Shrouk is pursuing a Master of Science in Data Science from Symbiosis International University, with an expected graduation date of December 2025. She also holds a Bachelor of Science degree from CCS University, Meerut, and has completed relevant coursework through AlmaBetter''s Full Stack Data Science program and Udemy''s ML &amp; DS Bootcamp 2023. Key Skills Shrouk possesses expert-level proficiency in Python and SQL, and intermediate-level skills in Java. Her expertise encompasses various databases (PostgreSQL, MySQL), tools and libraries (Scikit-learn, Pandas, NumPy, Matplotlib, Seaborn, NLTK, SHAP, TensorFlow, AWS, Google Colab, Jupyter Notebook, Tableau, Flask, PyCharm, Heroku), and a wide range of machine learning techniques (linear models, classification models, ensemble models, clustering algorithms, NLP techniques, recommendation systems, web scraping, data mining, data visualization, ETL processes). Experience Highlights Shrouk''s experience includes database management using SQL and client/developer liaison at Zixokart (dates needed). She also completed a training period (dates and organization name needed) focusing on further development in her field. Her project portfolio includes a deployed book recommendation system on Heroku, a health insurance cross-sell prediction model achieving a high recall rate, and an appliance energy prediction model utilizing various regression techniques. Additional Information Shrouk has demonstrated leadership skills as a subject matter expert in a doubt resolution forum at AlmaBetter and has published articles on Medium. She is described as proactive and data-driven, and possesses intermediate English language skills.</p>', CAST(N'2025-04-30' AS Date), N'IT/Computing', N'assiut', N'Part Time', N'Senior Level', N'1-2 years', N'Bachelors/Masters in Computer Science or Computer Engineering.', CAST(20000.00 AS Numeric(10, 2)), 4)
INSERT [dbo].[api_job] ([id], [title], [description], [expiry_date], [category], [location], [type], [level], [experience], [qualification], [salary], [recruiter_id]) VALUES (8, N'Software Engineer', N'<p>a highly skilled Senior Software Engineer with five years of experience in developing and optimizing large-scale web applications.&nbsp;His expertise lies in Python and JavaScript development, and he possesses strong leadership skills honed through managing development teams in Agile environments. He consistently delivers high-quality code and demonstrates a proven ability to improve application performance and deployment efficiency.</p><p>Education</p><p> holds a Bachelor of Science degree in Computer Science from the University of California, Berkeley, graduating with a 3.8 GPA. He also holds an AWS Certified Developer – Associate certification, showcasing his cloud computing proficiency.</p><p>Key Skills</p><p>His technical skills encompass a range of programming languages, including Python, JavaScript, and TypeScript. He is proficient in frameworks like Django, Flask, and React, and databases such as PostgreSQL and MySQL.&nbsp;Furthermore, he is experienced with tools like Git, Docker, and Jenkins, and he demonstrates expertise in Agile methodologies and team leadership.</p>', CAST(N'2025-04-30' AS Date), N'IT/Computing', N'San Francisco', N'Full Time', N'Mid Level', N'3-5 years', N'Bachelors in Computer Science or Computer Engineering.', CAST(100000.00 AS Numeric(10, 2)), 8)
INSERT [dbo].[api_job] ([id], [title], [description], [expiry_date], [category], [location], [type], [level], [experience], [qualification], [salary], [recruiter_id]) VALUES (10, N'Software Engineer', N'<p> a highly skilled Senior Software Engineer with five years of experience in developing and optimizing large-scale web applications.&nbsp;His expertise lies in Python and JavaScript development, and he possesses strong leadership skills honed through managing development teams in Agile environments. He consistently delivers high-quality code and demonstrates a proven ability to improve application performance and deployment efficiency.</p><p><br></p><p>Education</p><p>holds a Bachelor of Science degree in Computer Science from the University of California, Berkeley, graduating with a 3.8 GPA. He also holds an AWS Certified Developer – Associate certification, showcasing his cloud computing proficiency.</p><p><br></p><p>Key Skills</p><p><br></p><p>His technical skills encompass a range of programming languages, including Python, JavaScript, and TypeScript. He is proficient in frameworks like Django, Flask, and React, and databases such as PostgreSQL and MySQL.&nbsp;Furthermore, he is experienced with tools like Git, Docker, and Jenkins, and he demonstrates expertise in Agile methodologies and team leadership.</p><p><br></p>', CAST(N'2025-04-30' AS Date), N'IT/Computing', N'San Francisco', N'Full Time', N'Mid Level', N'3-5 years', N'Bachelors in Computer Science or Computer Engineering.', CAST(100000.00 AS Numeric(10, 2)), 4)
INSERT [dbo].[api_job] ([id], [title], [description], [expiry_date], [category], [location], [type], [level], [experience], [qualification], [salary], [recruiter_id]) VALUES (17, N'Frontend Developer', N'<h3><br></h3><h3>Job Overview</h3><p>We are seeking a talented Frontend Developer to join our dynamic team in Assiut, Egypt. The ideal candidate will have a passion for creating visually appealing and user-friendly web applications, with hands-on experience in modern frontend frameworks and tools. This role involves collaborating with backend developers and designers to deliver seamless user experiences for our web-based projects.</p><h3>Responsibilities</h3><ul><li>Develop responsive and interactive web interfaces using frameworks like React.js, Vue.js, or Angular.</li><li>Collaborate with UI/UX designers to implement pixel-perfect designs.</li><li>Optimize web applications for performance, accessibility, and cross-browser compatibility.</li><li>Integrate RESTful APIs with the frontend, ensuring smooth data flow between client and server.</li><li>Maintain and improve existing web applications by implementing animations, transitions, and SEO best practices.</li></ul><h3>Qualifications</h3><ul><li><strong>Education:</strong> B.Sc. in IT Engineering or a related field from a recognized university (e.g., Faculty of Computers and Information, Assiut University, Cairo University, or Ain Shams University).</li><li><strong>Experience:</strong> 1-2 years of experience in frontend development, including internships (e.g., experience at TechTrend Innovations, PixelCraft Studios, InnoWeb Creations, or WebSphere Innovations).</li><li><strong>GPA:</strong> Minimum 3.45 or higher.</li></ul><h3>Skills</h3><ul><li>Proficiency in HTML, CSS, and JavaScript (Expert level).</li><li>Experience with frontend frameworks such as React.js, Vue.js, or Angular (Intermediate to Advanced).</li><li>Familiarity with CSS frameworks like Tailwind CSS, Bootstrap, SCSS, or Material-UI (Advanced).</li><li>Knowledge of UI/UX design principles, web accessibility, and web performance optimization (Intermediate).</li><li>Experience with version control tools like Git (Beginner to Intermediate).</li><li>Understanding of TypeScript and SEO basics (Beginner, preferred).</li></ul><h3>Languages</h3><ul><li>Fluency in English and Arabic (Native).</li></ul><h3>Preferred Certificates</h3><ul><li>React.js Essentials by Coursera, Vue.js for Beginners by Udemy, Angular Basics by Udemy, or React.js for Web Development by Coursera.</li></ul><h3>Location</h3><ul><li>Assiut or Cairo, Egypt (hybrid work arrangement available).</li></ul><h3><br></h3>', CAST(N'2025-05-14' AS Date), N'Software Development', N'assiut', N'Part Time', N'Senior Level', N'0 years', N'Bachelors in Computer Science or Computer Engineering.', CAST(95000.00 AS Numeric(10, 2)), 15)
INSERT [dbo].[api_job] ([id], [title], [description], [expiry_date], [category], [location], [type], [level], [experience], [qualification], [salary], [recruiter_id]) VALUES (18, N'Backend Developer', N'<h1><br></h1><h3>Job Overview</h3><p>We are looking for a skilled Backend Developer to join our innovative team in Assiut, Egypt. The ideal candidate will have a strong background in server-side development, with expertise in building scalable and secure APIs for web applications. This role involves working closely with frontend developers to ensure seamless integration and optimal performance of our platforms.</p><h3>Responsibilities</h3><ul><li>Develop and maintain RESTful APIs using frameworks like Node.js, Django, or Spring Boot.</li><li>Design and optimize database schemas using SQL databases (e.g., PostgreSQL, MySQL) or NoSQL databases (e.g., MongoDB).</li><li>Implement secure backend services, ensuring data validation and protection.</li><li>Collaborate with frontend developers to integrate APIs and ensure smooth data flow.</li><li>Optimize server-side performance through efficient query design and application scalability.</li></ul><h3>Qualifications</h3><ul><li><strong>Education:</strong> B.Sc. in IT Engineering or a related field from a recognized university (e.g., Faculty of Computers and Information, Assiut University, or Egyptian E-Learning University).</li><li><strong>Experience:</strong> 1-2 years of experience in backend development, including internships (e.g., experience at CodeNest Solutions, DataSync Technologies, or Samar Training).</li><li><strong>GPA:</strong> Minimum 3.27 or higher.</li></ul><h3>Skills</h3><ul><li>Proficiency in programming languages such as Node.js, Python, or Java (Advanced to Expert).</li><li>Experience with frameworks like Express.js, Django, or Spring Boot (Intermediate to Advanced).</li><li>Strong knowledge of databases like PostgreSQL, MySQL, or MongoDB (Advanced).</li><li>Familiarity with API development and cloud services (e.g., AWS) (Intermediate to Beginner).</li><li>Understanding of unit testing, Docker, and networking (Beginner to Intermediate).</li><li>Experience with version control tools like Git (Intermediate).</li></ul><h3>Languages</h3><ul><li>Fluency in English and Arabic (Native).</li></ul><h3>Preferred Certificates</h3><ul><li>Node.js &amp; Express Certification by Udemy, Django for APIs by Coursera, or SC900 Microsoft.</li></ul><h3>Location</h3><ul><li>Assiut, Egypt (hybrid work arrangement available).</li></ul><h3>Why Join Us?</h3><p>Be part of a collaborative team where your technical expertise will drive the backbone of our web applications. Work on impactful projects, from job portals to banking systems, with opportunities to grow your skills in a supportive and innovative environment.</p>', CAST(N'2025-05-14' AS Date), N'Software Development', N'assiut', N'Part Time', N'Senior Level', N'1 years', N'Bachelors in Computer Science or Computer Engineering.', CAST(95000.00 AS Numeric(10, 2)), 14)
SET IDENTITY_INSERT [dbo].[api_job] OFF
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (2, N'Job Seeker One', N'remote', N'full-time', N'Cairo', CAST(5000.00 AS Numeric(10, 2)), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (3, N'Salma Mohamed', N'onsite', N'part-time', N'assiut', CAST(20000.00 AS Numeric(10, 2)), N'Fulkar Khan:  A Qualified Candidate for ML Deployment, Data Engineering

Introduction

Fulkar Khan is an enthusiastic data scientist with over two years of experience in predictive modeling, descriptive, and prescriptive analysis using machine learning.  His key strengths lie in his proficiency in Python and SQL, coupled with his experience in deploying models and managing databases. He possesses a strong data-driven mindset and consistently delivers actionable insights.

Education

Mr. Khan holds a Bachelor of Science degree from CCS University, Meerut, and is currently pursuing a Master of Science in Data Science from Symbiosis International University.  He has also completed relevant coursework through AlmaBetter''s Full Stack Data Science program and Udemy''s ML & DS Bootcamp 2023.  He is a TripleByte Certified Engineer, signifying proficiency in top machine learning and data science skills.

Key Skills

His technical skills encompass a wide range of programming languages (Python, SQL), databases (PostgreSQL, MySQL), and tools and libraries including Scikit-learn, Pandas, NumPy, Matplotlib, Seaborn, NLTK, SHAP, TensorFlow, AWS, Google Colab, Jupyter Notebook, Tableau, Flask, PyCharm, and Heroku.  His machine learning expertise includes various model types, such as linear models, classification models, ensemble models, clustering algorithms, NLP techniques, and recommendation systems. He is also experienced in web scraping, data mining, data visualization, and ETL processes.

Experience Highlights

During his internship at AlmaBetter, Mr. Khan significantly improved his skills in Python, SQL, and machine learning techniques.  His independent projects showcase his ability to develop and deploy machine learning models.  For instance, he built a book recommendation system deployed on Heroku, demonstrating proficiency in model building, deployment, and performance optimization.  He also developed a health insurance cross-sell prediction model, achieving a high recall rate, and an appliance energy prediction model using various regression techniques.  Prior to his internship, his role at Zixokart involved database management using SQL and liaising between clients and developers.

Additional Information

Beyond his technical skills, Mr. Khan demonstrates strong communication skills through his role as a Subject Matter Expert in a doubt resolution forum at AlmaBetter.  His publications on Medium demonstrate his ability to communicate complex technical concepts.  He possesses additional soft skills including a proactive and data-driven mindset, as evidenced by his numerous accomplishments and projects. He also lists reading, watching movies, and traveling among his interests.', N'Data Scientist', 0, NULL, NULL)
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (5, N'shrouk khairy', N'onsite', N'part-time', N'assiut', CAST(20000.00 AS Numeric(10, 2)), N'Shrouk Khairy: TripleByte Certified Engineer Candidate Profile

Introduction

Shrouk Khairy is a data scientist with over two years of experience in machine learning, specializing in predictive, descriptive, and prescriptive analysis.  Her key strengths lie in model deployment, database management, and delivering actionable insights using a strong data-driven approach.  She holds a TripleByte Engineer certification, demonstrating high technical proficiency.

Education

Shrouk is pursuing a Master of Science in Data Science from Symbiosis International University, with an expected graduation date of December 2025.  She also holds a Bachelor of Science degree from CCS University, Meerut, and has completed relevant coursework through AlmaBetter''s Full Stack Data Science program and Udemy''s ML & DS Bootcamp 2023.

Key Skills

Shrouk possesses expert-level proficiency in Python and SQL, and intermediate-level skills in Java.  Her expertise encompasses various databases (PostgreSQL, MySQL), tools and libraries (Scikit-learn, Pandas, NumPy, Matplotlib, Seaborn, NLTK, SHAP, TensorFlow, AWS, Google Colab, Jupyter Notebook, Tableau, Flask, PyCharm, Heroku), and a wide range of machine learning techniques (linear models, classification models, ensemble models, clustering algorithms, NLP techniques, recommendation systems, web scraping, data mining, data visualization, ETL processes).

Experience Highlights

Shrouk''s experience includes database management using SQL and client/developer liaison at Zixokart (dates needed).  She also completed a training period (dates and organization name needed) focusing on further development in her field.  Her project portfolio includes a deployed book recommendation system on Heroku, a health insurance cross-sell prediction model achieving a high recall rate, and an appliance energy prediction model utilizing various regression techniques.

Additional Information

Shrouk has demonstrated leadership skills as a subject matter expert in a doubt resolution forum at AlmaBetter and has published articles on Medium.  She is described as proactive and data-driven, and possesses intermediate English language skills.', N'Machine Learning Engineer', 0, N'senior', N'jobseeker_images/image222_GZhG6EO.jpg')
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (6, N'john doe', N'hybrid', N'full-time', N'San Francisco', CAST(95000.00 AS Numeric(10, 2)), N'John Doe: Senior Software Engineer Candidate Profile

Introduction

John Doe is a highly skilled Senior Software Engineer with five years of experience in developing and maintaining scalable web applications. His expertise lies in Python and JavaScript development, utilizing frameworks like Django, Flask, and React.  He demonstrates a strong ability to deliver high-quality code within Agile environments and consistently seeks opportunities for optimization and improvement.

Education

Mr. Doe holds a Bachelor of Science degree in Computer Science from the University of California, Berkeley, graduating with a 3.8 GPA.  He also possesses an AWS Certified Developer – Associate certification, demonstrating proficiency in cloud-based development.

Key Skills

His technical skills encompass a range of programming languages including Python, JavaScript, and TypeScript, along with frameworks such as Django, Flask, and React.  He is experienced with databases including PostgreSQL and MySQL, and utilizes tools like Git, Docker, and Jenkins for efficient development and deployment.  His professional skills include Agile methodologies and team leadership.

Experience Highlights

As a Senior Software Engineer at TechCorp, John led a team of three developers, building and maintaining a high-traffic customer-facing web application using Django and React, serving over 100,000 users.  He significantly optimized database queries in PostgreSQL, achieving a 30% reduction in response time.  Prior to this, at StartUp Inc., he developed RESTful APIs using Flask, integrated them with JavaScript frontends, and implemented CI/CD pipelines, resulting in a 40% increase in deployment frequency.

Additional Information

Beyond his technical expertise, John possesses strong soft skills, including effective team leadership and a demonstrated understanding of Agile development principles.  He prefers a hybrid work model and his salary expectation is $95,000 per year.', N'Senior Software Engineer', 95, N'mid', N'jobseeker_images/images_KfV0buE.jfif')
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (7, N'Sarah Smith', N'hybrid', N'full-time', N'Austin', CAST(75000.00 AS Numeric(10, 2)), N'Sarah Smith: A Promising Junior Software Engineer

Introduction

Sarah Smith is a highly motivated Junior Software Engineer with two years of experience in web development. Her key strengths lie in her proficiency with Python and JavaScript, coupled with practical experience using frameworks like Django and Flask.  She seeks a challenging role in a collaborative environment where she can contribute to innovative projects.

Education

Ms. Smith holds a Bachelor of Science degree in Information Technology from the University of Texas at Austin, graduating in 2023 with a GPA of 3.5/4.0.  She further enhanced her skills by completing the Coursera certification in Python for Everybody in 2022.

Key Skills

Her technical skills encompass programming languages such as Python and JavaScript, along with experience in frameworks like Django and Flask.  She is proficient in working with MySQL databases and utilizes tools such as Git and VS Code.  Beyond technical skills, she possesses strong communication and problem-solving abilities.

Experience Highlights

During her internship at WebSolutions (2022-2023), she actively participated in the development of web applications using Django and JavaScript, contributing to reporting features through SQL queries in MySQL.  Her experience included involvement in Agile sprints and code reviews. Prior to her internship, she worked as a freelance developer (2021-2022), building small-scale websites using Python (Flask) and JavaScript for various clients.

Additional Information

Ms. Smith is open to both hybrid and remote work arrangements and has a salary expectation of $75,000 per year.  Her demonstrated soft skills, including strong communication and problem-solving, further enhance her qualifications.', N'Junior Software Engineer', 0, N'mid', NULL)
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (9, N'Asmaa Atef Hassan', N'onsite', N'part-time', N'assiut', CAST(95000.00 AS Numeric(10, 2)), N'Asmaa Atef Hassan: Frontend Developer Candidate Profile

Introduction

Asmaa Atef Hassan is a dedicated Frontend Developer with approximately four years of experience in IT, demonstrated through her internship and academic background.  Her key strengths lie in building responsive and user-friendly web applications using modern frameworks such as React.js and Tailwind CSS, with a focus on creating seamless user experiences.

Education

Ms. Hassan holds a Bachelor of Science degree in IT Engineering from the Faculty of Computers and Information at Assiut University, achieving a GPA of 3.45.  Her studies concluded in June 2025. She also completed a React.js Essentials certification from Coursera in summer 2024.

Key Skills

Ms. Hassan possesses expert-level skills in JavaScript, HTML, and CSS.  She demonstrates advanced proficiency in React.js and Tailwind CSS, complemented by intermediate skills in UI/UX design principles, Git version control, and responsive web design.

Experience Highlights

During her Frontend Developer internship at TechTrend Innovations (June-August 2024), Ms. Hassan developed responsive web interfaces using React.js and Tailwind CSS for a client project. She successfully collaborated with the design team to ensure pixel-perfect implementation of UI designs.

Additional Information

Ms. Hassan is fluent in both Arabic and English.  Her dedication to her field and her passion for creating seamless user experiences make her a strong candidate for frontend development roles.', N'Frontend Developer', 90, N'senior', N'jobseeker_images/1745881720891.jpg')
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (10, N'Yasmeen Elewa Ahmed', N'onsite', N'part-time', N'assiut', CAST(95000.00 AS Numeric(10, 2)), N'Yasmeen Elewa Ahmed: Backend Developer Candidate Profile

Introduction

Yasmeen Elewa Ahmed is a highly motivated backend developer with over a year of experience in software development, primarily focusing on server-side application development.  Her key strengths lie in building robust and scalable applications using Node.js, Express.js, and SQL, with a demonstrated commitment to optimizing system performance.  She is currently pursuing a Bachelor of Science degree in IT Engineering.

Education

Ms. Ahmed is nearing completion of her B.Sc. in IT Engineering from the Faculty of Computers and Information at Assiut University, achieving a GPA of 3.60.  She also holds a Node.js & Express certification from Udemy.

Key Skills

Ms. Ahmed possesses advanced skills in Node.js and Express.js, and expert-level proficiency in SQL. Her skills also extend to intermediate levels in MongoDB and Git version control, along with beginner-level experience in AWS cloud services.  She is highly proficient in API development.

Experience Highlights

During her recent internship at CodeNest Solutions, Yasmeen built RESTful APIs using Node.js and Express.js for a web application.  She significantly improved application performance by optimizing database queries using SQL.

Additional Information

Ms. Ahmed is a native Arabic speaker with advanced English proficiency.  Her demonstrated commitment to continuous learning and proven ability to deliver high-quality work make her a strong candidate for a backend developer position.', N'Backend Developer', 90, N'senior', N'jobseeker_images/1745881720899.jpg')
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (11, N'Nada Emad Sabry', N'onsite', N'full-time', N'assiut', CAST(95000.00 AS Numeric(10, 2)), N'Nada Emad Sabry: Frontend Developer Candidate Profile

Introduction

Nada Emad Sabry is a passionate frontend developer with an academic background in IT Engineering and approximately one year of practical experience.  Her key strengths lie in creating responsive and engaging web interfaces using Vue.js and Bootstrap, with a focus on user experience and accessibility.  She demonstrates commitment to clean, efficient coding practices and a keen interest in UI design.

Education

Ms. Sabry holds a Bachelor of Science degree in IT Engineering from the Faculty of Computers and Information at Assiut University, with a GPA of 3.60. Her studies concluded recently.  She has also completed a Vue.js for Beginners certification from Udemy.

Key Skills

Ms. Sabry possesses advanced skills in JavaScript and expert-level proficiency in HTML and CSS.  She has intermediate skills in Vue.js, Bootstrap, and Figma, along with intermediate knowledge of web accessibility.  Her experience with Git version control is currently at a beginner level.

Experience Highlights

During a frontend developer internship at PixelCraft Studios, Ms. Sabry designed and implemented interactive UI components using Vue.js and Bootstrap. She collaborated effectively with backend developers to integrate APIs into the frontend, showcasing her teamwork and integration abilities.

Additional Information

Ms. Sabry is a native Arabic speaker with advanced English proficiency.  Her commitment to user experience, combined with her technical skills and academic background, makes her a strong candidate for a frontend developer position.', N'Frontend Developer', 85, N'senior', N'jobseeker_images/1745881720895_EATVKH2.jpg')
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (12, N'Seif Taher Mohamed', N'onsite', N'part-time', N'assiut', CAST(95000.00 AS Numeric(10, 2)), N'Seif Taher Mohamed: Backend Developer Candidate Profile

Introduction

Seif Taher Mohamed is a motivated backend developer with approximately four years of experience in IT and a strong foundation in software development.  He possesses expertise in Python, Django, and PostgreSQL, and demonstrates a commitment to writing clean, efficient code while optimizing database performance.  His key strengths include API development, database management, and a dedication to building scalable applications.

Education

Seif holds a Bachelor of Science degree in IT Engineering from the Faculty of Computers and Information at Assiut University, graduating with a GPA of 3.50 (expected graduation June 2025).  He has also completed a Coursera certification in Django for APIs.

Key Skills

Seif''s technical skills encompass expertise in Python programming and advanced proficiency in the Django framework and PostgreSQL database.  He has intermediate skills in Django REST Framework, REST API development, Git, and unit testing, and beginner-level experience with Docker.

Experience Highlights

During a recent internship at DataSync Technologies, Seif developed secure APIs using Django REST Framework for a job portal application. He further honed his skills by implementing database migrations and optimizing queries within PostgreSQL, showcasing his ability to contribute directly to application development and performance enhancement.

Additional Information

Seif is fluent in both Arabic and English, further enhancing his communication and collaboration abilities.  His demonstrated dedication to continuous learning, as evidenced by his pursuit of relevant certifications, positions him as a valuable asset to a development team.', N'Backend Developer', 90, N'senior', N'')
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (13, N'Abdallah Ali Mohamed', N'onsite', N'part-time', N'assiut', CAST(95000.00 AS Numeric(10, 2)), N'Frontend Developer Candidate Profile: Abdullah Ali Mohamed

Introduction

Abdullah Ali Mohamed is a proactive Frontend Developer with over a year of experience in the field.  His primary focus is building dynamic and high-performance web applications, leveraging his expertise in Angular and SCSS.  He is known for his passion for optimizing user interfaces and delivering visually appealing and efficient solutions for modern web platforms.

Education

Mr. Mohamed holds a Bachelor of Science degree in IT Engineering from the Faculty of Computers and Information, Cairo University, which he is currently pursuing (expected graduation 06/2025). He maintains a GPA of 3.70.  He also recently completed an Angular Basics certification course on Udemy.

Key Skills

His technical skills include expert-level proficiency in HTML/CSS and advanced skills in JavaScript and SCSS.  He possesses intermediate skills in Angular, web performance optimization, and Git version control.  He is also a beginner in TypeScript.

Experience Highlights

During his internship as a Frontend Developer at InnoWeb Creations (June-August 2024), Mr. Mohamed built dynamic web pages using Angular and SCSS for a corporate website.  He significantly contributed to improving website performance by optimizing assets and reducing load times.

Additional Information

Mr. Mohamed is a native Arabic speaker and fluent in English.  His proactive nature and dedication to user experience optimization are valuable assets.', N'Frontend Developer', 85, N'senior', N'')
INSERT [dbo].[api_jobseeker] ([user_id], [full_name], [work_mode], [preferred_job_type], [preferred_location], [salary_expectation], [overview], [classification], [score], [experience_level], [profile_image]) VALUES (16, N'Salma Mohamed Saad', N'onsite', N'part-time', N'assiut', CAST(95000.00 AS Numeric(10, 2)), N'Salma Mohamad Saad: Backend Developer Candidate Profile

Introduction

Salma Mohamad Saad is a highly motivated Backend Developer with internship experience and a strong academic background in IT Engineering.  She possesses a solid foundation in Java and Spring Boot, demonstrating expertise in building secure and scalable backend systems for financial applications.  Her key strengths lie in database management, application development, and a commitment to delivering high-quality solutions.

Education

Ms. Saad is currently pursuing a Bachelor of Science in IT Engineering from the Egyptian E-Learning University, expected to graduate in June 2025, with a GPA of 3.57. She also holds a SC900 Microsoft certification obtained in August 2024.

Key Skills

Her technical skills include advanced proficiency in Java and MySQL, intermediate skills in Spring Boot, Git version control, and software engineering principles.  She also possesses intermediate knowledge of Natural Language Processing and beginner-level networking skills.

Experience Highlights

During a recent internship at Samar Training, Ms. Saad contributed to the development of backend services for a banking application (Bank Masir). Her responsibilities included designing database schemas, implementing data validation for secure transactions, and utilizing Java and Spring Boot technologies.

Additional Information

Ms. Saad is fluent in both Arabic and English.  Her proactive nature and dedication to learning new technologies make her a valuable asset to any development team.', N'Backend Developer', 95, N'senior', N'jobseeker_images/1745881720908.jpg')
INSERT [dbo].[api_recruiter] ([user_id], [company_name], [company_description], [cover], [logo]) VALUES (1, N'Tech Corp', N'A tech company', NULL, NULL)
INSERT [dbo].[api_recruiter] ([user_id], [company_name], [company_description], [cover], [logo]) VALUES (4, N'mohamed', N'<p>company descreption</p>', N'images/pngtree-the-employees-of-a-company_6SunLwx.jpg', N'images/logo-design_Qu1I2PH.jpg')
INSERT [dbo].[api_recruiter] ([user_id], [company_name], [company_description], [cover], [logo]) VALUES (8, N'saad_zagloul', N'company descreption', NULL, NULL)
INSERT [dbo].[api_recruiter] ([user_id], [company_name], [company_description], [cover], [logo]) VALUES (14, N'Microsoft Corporation', N'<p>A global technology leader delivering innovative software, cloud solutions, and AI services to empower businesses and individuals.</p>', N'images/microsoft.jpg', N'images/questions_17297925387342.jpg')
INSERT [dbo].[api_recruiter] ([user_id], [company_name], [company_description], [cover], [logo]) VALUES (15, N'Google', N'<p>A technology giant specializing in search engines, cloud computing, AI, and innovative products like Android and Google Maps</p>', N'images/Google.jpg', N'images/google-chrome-icon.webp')
SET IDENTITY_INSERT [dbo].[api_user] ON 

INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (1, N'pbkdf2_sha256$720000$8xYI6vnFjmLGMcttLNtzzi$yP4y1ELeSTa71M+NWS9EL6joKQe7HBSM/ajqkrOs7Uo=', CAST(N'2025-04-14 16:50:45.2167540' AS DateTime2), N'recruiter1', CAST(N'2025-04-14 16:49:16.8423530' AS DateTime2), N'recruiter', N'recruiter1@example.com', N'Egypt', N'1234567890', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (2, N'pbkdf2_sha256$720000$IxN4fyt6wT6vJxfn4MJzgY$l0ZnEiKDkLRwLR+2eQcfhiX0PIkwe7aAu9rDQkDQm7o=', CAST(N'2025-04-14 23:53:36.5157530' AS DateTime2), N'jobseeker1', CAST(N'2025-04-14 16:50:02.9787080' AS DateTime2), N'job_seeker', N'jobseeker1@example.com', N'Egypt', N'0987654321', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (3, N'pbkdf2_sha256$720000$9ijY2G42X0B8hEtgjmg9tJ$FQopAr03pe9ukOVrw6Ppv+4Z2R6NvVdE48Ftfhwl0vs=', CAST(N'2025-04-28 06:36:00.0929810' AS DateTime2), N'salmamohamed0266@gmail.com', CAST(N'2025-04-15 00:40:59.0488310' AS DateTime2), N'job_seeker', N'salmamohamed0266@gmail.com', N'Egypt', N'01011740597', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (4, N'pbkdf2_sha256$720000$X0hBB5zyTqognVbSr7t03V$zS+kysUCEcd8rz2/zCUsJDC0/hZ6g/I3D7ZGAS8t0Tg=', CAST(N'2025-04-29 05:23:23.8089610' AS DateTime2), N'mohamed66@gmail.com', CAST(N'2025-04-15 02:32:07.2390020' AS DateTime2), N'recruiter', N'mohamed66@gmail.com', N'Egypt', N'01234567890', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (5, N'pbkdf2_sha256$720000$lQ4VK4k7bydolvqzntGYNN$D9l8zQOCatvSk3554qcGbQQ6MHKCT9/RGA5fo0hqHaM=', CAST(N'2025-04-30 15:46:03.7844660' AS DateTime2), N'shroukkhairy267@gmail.com', CAST(N'2025-04-15 14:13:37.0403960' AS DateTime2), N'job_seeker', N'shroukkhairy267@gmail.com', N'Egypt', N'01234567855', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (6, N'pbkdf2_sha256$720000$apv7ASWUz8Mr8lirLz2jxK$ENWzc6BC13zy5hMIHTbYFTDpLs3C/wug9N0z50paQNE=', CAST(N'2025-04-28 21:45:41.6186650' AS DateTime2), N'john.doe@example.com', CAST(N'2025-04-20 08:03:13.9231170' AS DateTime2), N'job_seeker', N'john.doe@example.com', N'San Francisco', N'+1-555-123-4567', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (7, N'pbkdf2_sha256$720000$ehDoTxLt0nBQwaznxrx7R5$1i6C8rpAkfw+VzgtQufGf7veB183CpPkESMDBfjpwfo=', CAST(N'2025-04-24 22:20:20.8045510' AS DateTime2), N'sarah.smith@example.com', CAST(N'2025-04-20 08:49:12.1019370' AS DateTime2), N'job_seeker', N'sarah.smith@example.com', N'Austin', N'+1-555-987-6543', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (8, N'pbkdf2_sha256$720000$K7f5DhpkxvSPG1TPskxriC$SSi1DL/0wv3dkD6vcbmWjjQKvdXVEkeUOkSJi81A68g=', CAST(N'2025-04-25 07:02:17.9282460' AS DateTime2), N'saad@gmail.com', CAST(N'2025-04-20 09:04:30.0148450' AS DateTime2), N'recruiter', N'saad@gmail.com', N'Egypt', N'01234567890', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (9, N'pbkdf2_sha256$720000$osh9yDyteGxZJXkoqhe1wX$GaTSyjLOHMjfsAL9YQde8dn54HZyAygiMOn30KCiI08=', CAST(N'2025-04-29 08:41:18.0990990' AS DateTime2), N'Asmaa2003@gmail.com', CAST(N'2025-04-28 21:56:49.1998590' AS DateTime2), N'job_seeker', N'Asmaa2003@gmail.com', N'Assiut', N'01126567539', 0, 0, 1, N'Asmaa Atef Hassan', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (10, N'pbkdf2_sha256$720000$XGLVYpnRo2XiChuNCjiPcv$Exo2FcPNUUQJCMRtcHD0ZbgWz8qYBJ5wgGeOb0M4ZLw=', CAST(N'2025-04-29 08:48:44.0804870' AS DateTime2), N'Yasmeen2003@gmail.com', CAST(N'2025-04-28 22:00:08.3702090' AS DateTime2), N'job_seeker', N'Yasmeen2003@gmail.com', N'Assiut', N'01027912138', 0, 0, 1, N'Yasmeen Elewa Ahmed', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (11, N'pbkdf2_sha256$720000$7m7AcOXjSXKD2GpX4lNiiE$mxPfnAG5NXF5VkGAbkzk2nAfcBrx7Tg3PCbu7bRMG00=', CAST(N'2025-04-29 08:40:59.1180180' AS DateTime2), N'Nada2002@gmail.com', CAST(N'2025-04-28 22:27:05.4973920' AS DateTime2), N'job_seeker', N'Nada2002@gmail.com', N'Assiut', N'01225744096', 0, 0, 1, N'Nada Emad Sabry', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (12, N'pbkdf2_sha256$720000$CDmIjAdk9cAHwELwWLcULe$p+Di5OVXmy2wIhb0Z2g+o+3yswUoA0vF0ZUokWf9Lnk=', CAST(N'2025-04-29 17:08:45.1687000' AS DateTime2), N'Seif2003@gmail.com', CAST(N'2025-04-28 22:30:17.6697310' AS DateTime2), N'job_seeker', N'Seif2003@gmail.com', N'Assiut', N'01507258135', 0, 0, 1, N'Seif Taher Mohamed', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (13, N'pbkdf2_sha256$720000$VNWgjPaZlFx27gJfDoxEuL$ty7UoKoX/07WSwbPf/L+EwXjc5sN+/szKVzgXoF8v5c=', CAST(N'2025-04-29 08:37:53.3912840' AS DateTime2), N'Abdallah2003@gmail.com', CAST(N'2025-04-28 22:31:55.6959930' AS DateTime2), N'job_seeker', N'Abdallah2003@gmail.com', N'Assiut', N'01142760215', 0, 0, 1, N'Abdallah Ali Mohamed', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (14, N'pbkdf2_sha256$720000$5I7eTsUpn7IqwYZcqBSVbF$xmkMeae3RxAPtiWBI/jeyfFwmgZDw8ragmLsX9Q+Rp0=', CAST(N'2025-04-29 08:45:18.6220170' AS DateTime2), N'info@microsoft.com', CAST(N'2025-04-28 22:38:33.4133270' AS DateTime2), N'recruiter', N'info@microsoft.com', N'Egypt', N'01265551234', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (15, N'pbkdf2_sha256$720000$0us0y2e3f0iHN5EBWXiCAG$s5/zAtdHT5/RWPjeYx5oIcq+4LF7D8mmxgXrF2KGIo0=', CAST(N'2025-04-29 16:57:57.5326740' AS DateTime2), N'contact@google.com', CAST(N'2025-04-28 22:40:20.4143820' AS DateTime2), N'recruiter', N'contact@google.com', N'Egypt', N'01065181234', 0, 0, 1, N'', N'', N'')
INSERT [dbo].[api_user] ([id], [password], [last_login], [username], [date_joined], [user_type], [email], [country], [phone], [is_superuser], [is_staff], [is_active], [full_name], [first_name], [last_name]) VALUES (16, N'pbkdf2_sha256$720000$McWP4LrpRNbjmOM1mKWN2c$YLH6NwJMmUniLBfsqVQUtIhYhSEQNFga29Q2hH5Hqf4=', CAST(N'2025-04-29 08:43:39.0293660' AS DateTime2), N'salma2002@gmail.com', CAST(N'2025-04-28 22:42:19.7931680' AS DateTime2), N'job_seeker', N'salma2002@gmail.com', N'Assiut', N'01011740597', 0, 0, 1, N'Salma Mohamed Saad', N'', N'')
SET IDENTITY_INSERT [dbo].[api_user] OFF
SET IDENTITY_INSERT [dbo].[auth_permission] ON 

INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (1, N'Can add log entry', 1, N'add_logentry')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (2, N'Can change log entry', 1, N'change_logentry')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (3, N'Can delete log entry', 1, N'delete_logentry')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (4, N'Can view log entry', 1, N'view_logentry')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (5, N'Can add permission', 2, N'add_permission')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (6, N'Can change permission', 2, N'change_permission')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (7, N'Can delete permission', 2, N'delete_permission')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (8, N'Can view permission', 2, N'view_permission')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (9, N'Can add group', 3, N'add_group')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (10, N'Can change group', 3, N'change_group')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (11, N'Can delete group', 3, N'delete_group')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (12, N'Can view group', 3, N'view_group')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (13, N'Can add content type', 4, N'add_contenttype')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (14, N'Can change content type', 4, N'change_contenttype')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (15, N'Can delete content type', 4, N'delete_contenttype')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (16, N'Can view content type', 4, N'view_contenttype')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (17, N'Can add session', 5, N'add_session')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (18, N'Can change session', 5, N'change_session')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (19, N'Can delete session', 5, N'delete_session')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (20, N'Can view session', 5, N'view_session')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (21, N'Can add user', 6, N'add_user')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (22, N'Can change user', 6, N'change_user')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (23, N'Can delete user', 6, N'delete_user')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (24, N'Can view user', 6, N'view_user')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (25, N'Can add job', 7, N'add_job')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (26, N'Can change job', 7, N'change_job')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (27, N'Can delete job', 7, N'delete_job')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (28, N'Can view job', 7, N'view_job')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (29, N'Can add job seeker', 8, N'add_jobseeker')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (30, N'Can change job seeker', 8, N'change_jobseeker')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (31, N'Can delete job seeker', 8, N'delete_jobseeker')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (32, N'Can view job seeker', 8, N'view_jobseeker')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (33, N'Can add recruiter', 9, N'add_recruiter')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (34, N'Can change recruiter', 9, N'change_recruiter')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (35, N'Can delete recruiter', 9, N'delete_recruiter')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (36, N'Can view recruiter', 9, N'view_recruiter')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (37, N'Can add notification', 10, N'add_notification')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (38, N'Can change notification', 10, N'change_notification')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (39, N'Can delete notification', 10, N'delete_notification')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (40, N'Can view notification', 10, N'view_notification')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (41, N'Can add application', 11, N'add_application')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (42, N'Can change application', 11, N'change_application')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (43, N'Can delete application', 11, N'delete_application')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (44, N'Can view application', 11, N'view_application')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (45, N'Can add Token', 12, N'add_token')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (46, N'Can change Token', 12, N'change_token')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (47, N'Can delete Token', 12, N'delete_token')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (48, N'Can view Token', 12, N'view_token')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (49, N'Can add Token', 13, N'add_tokenproxy')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (50, N'Can change Token', 13, N'change_tokenproxy')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (51, N'Can delete Token', 13, N'delete_tokenproxy')
INSERT [dbo].[auth_permission] ([id], [name], [content_type_id], [codename]) VALUES (52, N'Can view Token', 13, N'view_tokenproxy')
SET IDENTITY_INSERT [dbo].[auth_permission] OFF
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'150f60dbc3deaede4ce6ab42e7a2929085b3302d', CAST(N'2025-04-20 08:03:13.9733240' AS DateTime2), 6)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'173827d6e238a1da0f96814c5b18e8077ce1e69b', CAST(N'2025-04-28 22:42:19.8243730' AS DateTime2), 16)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'2f32f47e1b294e203d7934f7d19f707b9b6e1c57', CAST(N'2025-04-28 22:00:08.3929070' AS DateTime2), 10)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'3e8de8def7850b67563db80cdd20f543395ee7c8', CAST(N'2025-04-20 09:04:30.0343150' AS DateTime2), 8)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'6a621d004f300b7e060687d710c60f72b9917c53', CAST(N'2025-04-28 22:40:20.4300060' AS DateTime2), 15)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'70bb14e90facddb0852d9ed6f421ce6cc95dc643', CAST(N'2025-04-28 22:27:05.5170250' AS DateTime2), 11)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'738bfa6fa1605df14468e870418fd2b9a436364b', CAST(N'2025-04-14 16:49:16.8745560' AS DateTime2), 1)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'7d4e03a8c646914ae6bf72878530a969c81387ec', CAST(N'2025-04-15 14:13:37.1158590' AS DateTime2), 5)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'803eb5303dc2fc90d51e7fa163fcaed6f3bd091f', CAST(N'2025-04-14 16:50:03.0016130' AS DateTime2), 2)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'9e36040668c49beb95804431d7a231c56607f470', CAST(N'2025-04-15 02:32:07.8290280' AS DateTime2), 4)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'a19276ea9dd1dd211346618d498bf66b4bdc036d', CAST(N'2025-04-28 21:56:49.2422910' AS DateTime2), 9)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'a62c6ad9274dd8e288a723bc6798fb855f2f2399', CAST(N'2025-04-28 22:31:55.7149170' AS DateTime2), 13)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'c0328c4e8a38d1011d52eb5ff009cba8902d5e7e', CAST(N'2025-04-28 22:38:33.4289490' AS DateTime2), 14)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'c128a27c45a03c300cf857b9d6021db4c0229a03', CAST(N'2025-04-20 08:49:12.1219590' AS DateTime2), 7)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'c6e1df746954b61cb1e0f7fe50259a2ad6305619', CAST(N'2025-04-28 22:30:17.6879170' AS DateTime2), 12)
INSERT [dbo].[authtoken_token] ([key], [created], [user_id]) VALUES (N'ca2de33c03b2d3b2ba6ef4ffe1714d6fcd252a0e', CAST(N'2025-04-15 00:40:59.2357970' AS DateTime2), 3)
SET IDENTITY_INSERT [dbo].[django_content_type] ON 

INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (1, N'admin', N'logentry')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (11, N'api', N'application')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (7, N'api', N'job')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (8, N'api', N'jobseeker')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (10, N'api', N'notification')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (9, N'api', N'recruiter')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (6, N'api', N'user')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (3, N'auth', N'group')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (2, N'auth', N'permission')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (12, N'authtoken', N'token')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (13, N'authtoken', N'tokenproxy')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (4, N'contenttypes', N'contenttype')
INSERT [dbo].[django_content_type] ([id], [app_label], [model]) VALUES (5, N'sessions', N'session')
SET IDENTITY_INSERT [dbo].[django_content_type] OFF
SET IDENTITY_INSERT [dbo].[django_migrations] ON 

INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (1, N'contenttypes', N'0001_initial', CAST(N'2025-04-14 16:43:34.7410860' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (2, N'contenttypes', N'0002_remove_content_type_name', CAST(N'2025-04-14 16:43:35.1178730' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (3, N'auth', N'0001_initial', CAST(N'2025-04-14 16:43:35.1615800' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (4, N'auth', N'0002_alter_permission_name_max_length', CAST(N'2025-04-14 16:43:35.1724480' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (5, N'auth', N'0003_alter_user_email_max_length', CAST(N'2025-04-14 16:43:35.1815090' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (6, N'auth', N'0004_alter_user_username_opts', CAST(N'2025-04-14 16:43:35.1914800' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (7, N'auth', N'0005_alter_user_last_login_null', CAST(N'2025-04-14 16:43:35.2024530' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (8, N'auth', N'0006_require_contenttypes_0002', CAST(N'2025-04-14 16:43:35.2064410' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (9, N'auth', N'0007_alter_validators_add_error_messages', CAST(N'2025-04-14 16:43:35.2162060' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (10, N'auth', N'0008_alter_user_username_max_length', CAST(N'2025-04-14 16:43:35.2261860' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (11, N'auth', N'0009_alter_user_last_name_max_length', CAST(N'2025-04-14 16:43:35.2381470' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (12, N'auth', N'0010_alter_group_name_max_length', CAST(N'2025-04-14 16:43:35.4985120' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (13, N'auth', N'0011_update_proxy_permissions', CAST(N'2025-04-14 16:43:35.5055540' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (14, N'auth', N'0012_alter_user_first_name_max_length', CAST(N'2025-04-14 16:43:35.5129020' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (15, N'api', N'0001_initial', CAST(N'2025-04-14 16:43:35.6311980' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (16, N'admin', N'0001_initial', CAST(N'2025-04-14 16:43:35.6571260' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (17, N'admin', N'0002_logentry_remove_auto_add', CAST(N'2025-04-14 16:43:35.6680970' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (18, N'admin', N'0003_logentry_add_action_flag_choices', CAST(N'2025-04-14 16:43:35.6916800' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (19, N'authtoken', N'0001_initial', CAST(N'2025-04-14 16:43:35.7245900' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (20, N'authtoken', N'0002_auto_20160226_1747', CAST(N'2025-04-14 16:43:35.8049000' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (21, N'authtoken', N'0003_tokenproxy', CAST(N'2025-04-14 16:43:35.8108960' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (22, N'authtoken', N'0004_alter_tokenproxy_options', CAST(N'2025-04-14 16:43:35.8188600' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (23, N'sessions', N'0001_initial', CAST(N'2025-04-14 16:43:35.8318690' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (24, N'api', N'0002_jobseeker_experience_level', CAST(N'2025-04-15 05:29:20.1440710' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (25, N'api', N'0003_recruiter_cover_recruiter_logo', CAST(N'2025-04-22 11:12:29.0338910' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (26, N'api', N'0004_jobseeker_profile_image', CAST(N'2025-04-24 21:38:42.1564410' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (27, N'api', N'0005_alter_recruiter_cover_alter_recruiter_logo', CAST(N'2025-04-28 21:44:54.2741420' AS DateTime2))
INSERT [dbo].[django_migrations] ([id], [app], [name], [applied]) VALUES (28, N'api', N'0006_delete_notification', CAST(N'2025-04-28 21:44:54.4177580' AS DateTime2))
SET IDENTITY_INSERT [dbo].[django_migrations] OFF
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'05ihai0dixxtl4zdtb1x3vyd0rufjnh7', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8WfG:q8NnZ5Z6VkPl65qy34QpAyqR2xe9hFpH6cXK8pqfp3U', CAST(N'2025-05-10 06:57:18.9229840' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'06djv6ck0m9bsl1e2ao554vyle4xh73g', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8sQa:O8u70fxWaZ0pJ7-R8QpsqspjMpIZeJzFA6IcqNJm-hc', CAST(N'2025-05-11 06:11:36.8948100' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'0xzttlohzq2vpbpiktuu2qph5mmcnop3', N'.eJxVjEEOwiAQRe_C2pApUIe6dO8ZyMwAUjU0Ke3KeHfbpAvdvvf-f6tA61LC2tIcxqguquvU6RcyyTPV3cQH1fukZarLPLLeE33Ypm9TTK_r0f4dFGplW7NDawEJwCeD7GJ05F2Gc0aRxABobM_SZ2BjEXDwIkYINjLYnJ36fAH8-zgh:1u9YET:ob3_FLIqm_CPRuJymhOibi9eOkdCAzjrQDykkRAbvYk', CAST(N'2025-05-13 02:49:53.3800800' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'1awvlal7puikazlajoc9rfmhk7intmcz', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8tYZ:HmtZi7Ylyi-_1iMClxO2-_O1BVwoSBzyuBrYr3ZeV4M', CAST(N'2025-05-11 07:23:55.2356670' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'1eujj8upm0dzqh1u5jik1u3o7jayv175', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9dWY:xvXBfnB6nMOOTjemu07Z3xpVGARMRAQQINB_3fJpZhs', CAST(N'2025-05-13 08:28:54.9610250' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'1l0vor53avwtryggk4vhalaxk675zq8w', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8Umy:Zz_RTQSWBzOFWhJ4rom61zf3Jabr-ng8nmOGL4TuNAo', CAST(N'2025-05-10 04:57:08.9804000' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'1laxh96y15u7opp5rolwkj75jl06ue55', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9bHF:58tpvA1Y1Yq3TNdtSLmFZ_K0efd420JniuWF9CgxcDA', CAST(N'2025-05-13 06:04:57.6647800' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'1offdnyo39i03jt2v9imqrmpd66tq2xw', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u9ElC:_8p-Gxj-NIPL4mHOIQC9D4-cHhUcLLBwJsG8qtl1UTE', CAST(N'2025-05-12 06:02:22.9509780' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'21o5pizt0kv5br58yxsjswcyt66blvcs', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8VU3:hGduhb0scMvRI59v5WHvETGxsb-z2_vYzZSbL3C2zJY', CAST(N'2025-05-10 05:41:39.4976540' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'24wqa0lhremzebh64oezcbfiss1ypaz6', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u74zj:qMeLe5ZzAJhm1P0j9yaY0WQ4uGi3rLc7Vfk4KGLUfNU', CAST(N'2025-05-06 06:12:27.5607230' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'2616xz41cylit4rkle2n3rrpg7tnh0v4', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8t1O:Q0roATUhwrA6OkYO93H7L7CQ_W7dd7AN_U6mAppkdaY', CAST(N'2025-05-11 06:49:38.9228690' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'2jgnjjg7fbftv01zeqvcxx0ukue7hqls', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8Cpy:GoOz6WCuxq2Wi8e3RW9-mRD0_jOQz9WMMS3FDeYsIHg', CAST(N'2025-05-09 09:47:02.8676120' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'2r8f416obqq2n1uo3d4qalwt7n8s95nq', N'.eJxVjDsOwyAQBe9CHSHAfFOm9xnQwi7BSYQlY1dR7h4huUjaNzPvzSIce41Hpy0uyK5MCnb5HRPkJ7VB8AHtvvK8tn1bEh8KP2nn84r0up3u30GFXketNRkpSCkIOhGJrKTxUFzwQQYywqKziKXgpIoSlIC8ys74gmkyxbLPFw1qOKA:1u9dpk:WN6AOr6DPUQKawmmtvBS3yzQbEp0RSv90JplunV_OHQ', CAST(N'2025-05-13 08:48:44.0961030' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'2t9jhu9pjd196xlgubcbnhj04w21wxi4', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9btC:41Zf4O_I6PQSevjq1GHRAopwUG0ixFj8jy9cKDH82Jk', CAST(N'2025-05-13 06:44:10.9326700' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'2tgic1x311oi59v96ciqco5bsinteaqe', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9ZDY:Jzz8mxcmD4ZqDbZcZVZBmk9mqeTAT09UtxNoNP4uFmk', CAST(N'2025-05-13 03:53:00.4610990' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'30fonniss0t5duamf3esymwhylx5r953', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u79Z0:rcxhhY-AKPGokDChIHyI_bbjKN2Ml4lpIjZDJsGJwUE', CAST(N'2025-05-06 11:05:10.3133450' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'31n7xfzpwf5s3wmhqt52gh9nl4i4prdp', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u7zf2:j_cFpGD9q-3SxZnJVapJ0jCRieRKw4l_JKv3FC8x96k', CAST(N'2025-05-08 18:42:52.1867410' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'3ict7sjhkanfuywcdriv6uyy9aq0rc4c', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u971a:NwmLsJp7F3nfvpvXqRVjxZX2fnPLUxatJZsufLX4DiA', CAST(N'2025-05-11 21:46:46.2839080' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'3jz1zgzfp38fb5rcqvdshq3x8sfd7b02', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9acD:ty4vApxqHi8B7rtlOgi-WbzhX4ZeO8lUNvTu-c7TDSE', CAST(N'2025-05-13 05:22:33.5441300' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'3kh9twsodhx7vsqlik6dh05o581lrddu', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9Fod:8EqKFCX5DZddNX-Y7kjtPooDQHsMaismHOy9uSaEm8g', CAST(N'2025-05-12 07:09:59.7547380' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'3my46hqqlrm4m6ghbloiqfq1btd9yum4', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9dCt:EW-BAMQS6IJ2DZFAsQ_VdkfxSExfwy1iY3J_DJlXzLw', CAST(N'2025-05-13 08:08:35.4368370' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'3o277t4wgd9tmnf3b7l5k3x9s3zeicl6', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9DUQ:vNt07ZcEC4t_D9PQztyBaaeRfqANNnVleuNNMxVkBRI', CAST(N'2025-05-12 04:40:58.4999520' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'3x5paz2yuzk0woyjvwggr29zw6tkfrio', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9dfh:UZwNOj1CAMoSDv456TC8PSDZLzf6o6MFTpI5n7yAMMw', CAST(N'2025-05-13 08:38:21.8409930' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'417jp8eul8a33wej27occl94gi49i6aj', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u96XR:vtQXzpwmnLQiIJCFHArSF0HmQ3uoH7oZLBFvTV7PsV8', CAST(N'2025-05-11 21:15:37.3777650' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'456kn5j7hff037g2lot6ojazqcu0t1z3', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u79pT:M6GcdkU_2WsQPzPxS51s7AJBZ3tMhzb-8PwAPQODxtY', CAST(N'2025-05-06 11:22:11.0087610' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'4a927i9brkb404bkyxzmk8vnq1edofu8', N'.eJxVjEEOwiAQRe_C2pApUIe6dO8ZyMwAUjU0Ke3KeHfbpAvdvvf-f6tA61LC2tIcxqguquvU6RcyyTPV3cQH1fukZarLPLLeE33Ypm9TTK_r0f4dFGplW7NDawEJwCeD7GJ05F2Gc0aRxABobM_SZ2BjEXDwIkYINjLYnJ36fAH8-zgh:1u9YwG:7hq5rQx4lVMm0YlxO9YgKKB6W02D3kFLJ23YxeGc-fA', CAST(N'2025-05-13 03:35:08.0395660' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'4d5rdcfrlvfbli7rop5nw6a7wlxjhw2o', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8FeG:u-qJJF8wRGNs1EbRcCEYTQOHyc9lCFVI9_eHqBCykao', CAST(N'2025-05-09 12:47:08.5817590' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'4df3j2nru2tdzir57fmf20eeowlea3sj', N'.eJxVjEEOwiAQRe_C2pBCJwgu3XsGMsMMUjWQlHZlvLtt0oVu33v_v1XEdSlx7TLHidVFjer0ywjTU-ou-IH13nRqdZkn0nuiD9v1rbG8rkf7d1Cwl22NYITAOo_eYchkzoFNYpPHbKwQZgIOQdD6gcURCGcgpryRAYwH9fkCDu05Sg:1u88q9:ZQrVIQtjYtuuE91k5ag2ZKKC07dVN1rt6_1M4xut048', CAST(N'2025-05-09 05:30:57.8209180' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'4fmlrjfgjgw8x0ej2djk07oiy6kys9wo', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9dXM:4rGSPzLn06p2kFXFGmkLWr0U5Pz9hI_ZP0pV4rbF4q4', CAST(N'2025-05-13 08:29:44.5563880' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'4il4zhtga5dit97r7zkmdv0kmc5xrgke', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u9TU5:tDjBJ98bMU6sL3z7ydEtMD1k-c3NDAizJZvMHfe4crM', CAST(N'2025-05-12 21:45:41.6261600' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'4me1uc6x918mw9qetfyfkfvzbnoz2cmt', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8XGC:NgAT4acqpAGNAZJgbEBsLO6tqiPuP-GbCRCXu6o7AQk', CAST(N'2025-05-10 07:35:28.5725360' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'4nuycbwbw5uj5patl6k8pbfnah41mjjl', N'.eJxVjEEOwiAQRe_C2hCwDHRcuu8ZyMCAVA0kpV0Z765NutDtf-_9l_C0rcVvPS1-ZnERgzj9boHiI9Ud8J3qrcnY6rrMQe6KPGiXU-P0vB7u30GhXr712cbMiIZNJtQAOI4uUeSIQKAdqaytpgyYrNKaOZohOwwMCpRBzOL9Ae4kN-4:1u79Aj:g1N1MSjGuEEtu9_WvODGEWjZkemWmQsIhSNrnJg9_IA', CAST(N'2025-05-06 10:40:05.4231460' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'4unk1jxg0y11l7pjy1gni3ncyhg3y6kc', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u82h5:OIxUruvUes6BZVbdopdWZYRXkdCEYKnQ4xSckM1AGe0', CAST(N'2025-05-08 21:57:11.1610370' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'54whgberywn2iz4q2h3rjq4041d5c8n3', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8VTa:0FEeZktdZ1igVRjlQLKve13DS25g4mR2ZZkI2WUngP8', CAST(N'2025-05-10 05:41:10.1379110' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'5bvrjhz590214jdpmmv6jjpbnx9zb1ri', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8ZM2:0ouC2bOm9VPXUQHhdRwmzva-jpa2Tg9e1ycnEJt5f_c', CAST(N'2025-05-10 09:49:38.9270540' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'5c3j3jxzqai0v924d1h8kf4pjnip4t2g', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u80sL:JYc5gAnx-lCyNsPD5-rQZZCUvkskpRYisNEu_jTcwGA', CAST(N'2025-05-08 20:00:41.3418770' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'5d1b3pk0zezj8kpiexfidipw4d45pu32', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9dDh:z4P1S2NEnLDi5xvKUCFUrCIX-ESx7iM2Gsf9IfZ58vs', CAST(N'2025-05-13 08:09:25.2951940' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'5eq3vnocfl95i1mc29bfmy13y2lb1rzm', N'.eJxVjEEOwiAQRe_C2hBgWkSX7j0DmWEGqRpISrsy3l2bdKHb_977LxVxXUpcu8xxYnVWQR1-N8L0kLoBvmO9NZ1aXeaJ9KbonXZ9bSzPy-7-HRTs5Vtb5mSOBJglOOQsDj14D4QhpDEwsOMBnc9ZkjMJbRg98gkoWzDkBvX-ABiYOOE:1u746e:qxc9xk-YzOw-Ny4HVZdfl3jMY4jlzaRj9BiR-VDerdk', CAST(N'2025-05-06 05:15:32.1136940' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'5fqfvaqtdjxvy3xbayi08i4yty8r32k2', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u79hu:r7VfcJ0bWZ0FGoRwNF9nbw5Vx93E9upIlil2YXKEZ6k', CAST(N'2025-05-06 11:14:22.4295790' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'5vy1v4yv9im8ate169hneuclxh3ukh6n', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8joz:SjHPAj7qc91itD5b4oGK9-htfKDNS44US2hPNZrWvGo', CAST(N'2025-05-10 21:00:13.8449730' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'5ymlzxj3q53iwgpn9n5mdnpm3ufnuhx8', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8Zc9:u_ER5TZP5x5bCEqoYQCAMYmdwbDECN0p-gFx5KOH8L4', CAST(N'2025-05-10 10:06:17.6542800' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'5zeahe58ah1526d8okkl06u98id8qda4', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u7ynE:iX8htduaCBaDmwhSELcCetPfFhlwhZosoVYPT_16HzQ', CAST(N'2025-05-08 17:47:16.9354450' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'6be09nnkztgunrxeq8dbj8544nqfd8yp', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8W98:4fvxpG3LrZ3wb-0nSc5n7j9rbwr7mVmEyBXm8kVoz2c', CAST(N'2025-05-10 06:24:06.5754010' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'6e928a9rlcoudesrs4hxx93opeeeisbf', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8nWa:YXRD_lT3Ofu0NZnlatG2HIdqKFexWgrbNAnFYt0oRE8', CAST(N'2025-05-11 00:57:28.4715730' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'6h9nqa6x9227ls1irs8mwuvq20oowv2r', N'.eJxVjEEOwiAQRe_C2hBgKIwu3XsGMjAgVUOT0q6Md7dNutDtf-_9twi0LjWsPc9hZHERXpx-t0jpmdsO-EHtPsk0tWUeo9wVedAubxPn1_Vw_w4q9brV1lh3dkVnLDZaNK44RAAevHNAkDQoLmAQVCQDKSuL7AdPWm-BYhafL7ltNuw:1u81lH:AyTLw0SOg7FMLhT8wz1uQ-lZHgGgiCNeNWuLwVUENVk', CAST(N'2025-05-08 20:57:27.7775000' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'6pm55ujis2on2qe7zdbyz5hu2ufy8wis', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9Tfl:agbx413Sh_KUqhbblOhIBfjsr1VO_doMQfhhlWJAKwk', CAST(N'2025-05-12 21:57:45.7312790' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'6to0l8gx22t0tguvnlfaqj27redo69wm', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8Czo:F0cRwzPTQpBjhxu3g80OeIHPWKLq1rQsEYBmMcabWeA', CAST(N'2025-05-09 09:57:12.4640960' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'74jovu9fojlv68tzl3npwwk30cse12u2', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u7ymR:0Jiq-E-goo06Ltm8sLapOOOO3O4_EOOBT1ACozkhrJQ', CAST(N'2025-05-08 17:46:27.4411140' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'77unc6zavtlsfvq241fpsh8sb2zlzgvx', N'.eJxVjEEOwiAQRe_C2pBCJwgu3XsGMsMMUjWQlHZlvLtt0oVu33v_v1XEdSlx7TLHidVFjer0ywjTU-ou-IH13nRqdZkn0nuiD9v1rbG8rkf7d1Cwl22NYITAOo_eYchkzoFNYpPHbKwQZgIOQdD6gcURCGcgpryRAYwH9fkCDu05Sg:1u9F6C:HyqmBz8QfmRPomu9A5ySzeMU9BjEmVHs7jsBC1Bbd9E', CAST(N'2025-05-12 06:24:04.2591470' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'7j67enbw91jffy5fngehu1i6207mnsyw', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8nYl:KlON0IZOVIvHPT5V7y2qxtzkShNVh0_xasZw1fMNM6o', CAST(N'2025-05-11 00:59:43.6327790' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'7opiprjgpjcb8pl5f9d3fpz7vu8vkyyb', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9F9O:-usxbHhg8NEyhXVcIXs7MGeI_wzznW7LgS6BxLhYR20', CAST(N'2025-05-12 06:27:22.8385300' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'83p3140pw3o5t4u29go21rhchtorclfz', N'.eJxVjMsOwiAQRf-FtSHAMDxcuvcbyPCoVA0kpV0Z_12bdKHbe865LxZoW2vYRlnCnNmZOXb63SKlR2k7yHdqt85Tb-syR74r_KCDX3suz8vh_h1UGvVbe7RFupytR-fJOlQgSYD0kIxOWWsoWpGHItBZZUCBcmJKk0QyEcGw9weyZDZn:1u89Xn:sAobk9fRFRfv938a1jqXvo4ZuI4W89nwV1sjL7i9-RM', CAST(N'2025-05-09 06:16:03.0079690' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'8gb3zpl9riycwt5awyrguoz5xeoi0t63', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8nol:h6x8PnGkUoe-Wzau8NDmSxt5EvHBL5n8Ty6f6H-9F9s', CAST(N'2025-05-11 01:16:15.1014620' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'8grrslqdef5engjwntc7zfk4ibrl943j', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9XhR:omJhaJHPGaMzAQxmR9Ml1lkNe8LQ6bwflkxZ8VjDO2s', CAST(N'2025-05-13 02:15:45.3459010' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'8la0uff4x6zbdfb63csf0y3b2c351n2m', N'.eJxVjEEOwiAQRe_C2hCwDHRcuu8ZyMCAVA0kpV0Z765NutDtf-_9l_C0rcVvPS1-ZnERgzj9boHiI9Ud8J3qrcnY6rrMQe6KPGiXU-P0vB7u30GhXr712cbMiIZNJtQAOI4uUeSIQKAdqaytpgyYrNKaOZohOwwMCpRBzOL9Ae4kN-4:1u78k0:9VUkx80-udgTcYiESoosr3Z2ThxYW8STNxF3HAUhAN4', CAST(N'2025-05-06 10:12:28.7579500' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'90xi7m7sh3qcomasbw98mroe55zgg82r', N'.eJxVjMsOwiAQRf-FtSHAMDxcuvcbyPCoVA0kpV0Z_12bdKHbe865LxZoW2vYRlnCnNmZOXb63SKlR2k7yHdqt85Tb-syR74r_KCDX3suz8vh_h1UGvVbe7RFupytR-fJOlQgSYD0kIxOWWsoWpGHItBZZUCBcmJKk0QyEcGw9weyZDZn:1u79vp:dfRjAGQEnUEyHGsdn89HCPYGKJdaDXv7zuUusiB_rWw', CAST(N'2025-05-06 11:28:45.9267650' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'91jw46lfi3un3n045ikuwxpo8fv1q7qp', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8VUX:RYlJCI6CeSc4EH0A9jfncFKWhHoaC5leluqp8zsNlYM', CAST(N'2025-05-10 05:42:09.5567810' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'93dubu6v39wqgvsmrckns9qsxzk6kvu9', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9djr:X-TByFkuNPY2xq3vk0NQq5m1-XRDNo3KdXPoDN5bgyw', CAST(N'2025-05-13 08:42:39.9678640' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'9456exrodipwr64yf4geofwhkk62eobp', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u9Fdi:ESHBEiu8Kt7na2e3mYboUTGOu-nqKak9u4j3I0Cz9XM', CAST(N'2025-05-12 06:58:42.4422190' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'97ljud88k1khg3bm3zvmssp8y7za0oda', N'.eJxVjEEOwiAQRe_C2hBgKIwu3XsGMjAgVUOT0q6Md7dNutDtf-_9twi0LjWsPc9hZHERXpx-t0jpmdsO-EHtPsk0tWUeo9wVedAubxPn1_Vw_w4q9brV1lh3dkVnLDZaNK44RAAevHNAkDQoLmAQVCQDKSuL7AdPWm-BYhafL7ltNuw:1u833U:tLT4OLx-C4xHy67G1nJQA6QZ4izji5atIytuHryIxpQ', CAST(N'2025-05-08 22:20:20.8201720' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'9awqq1jtdj1tds73s0bjx1nv49djvfbg', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9Eeo:WvWyl5h0XTF81_QORfOyBq6gng0dsH7ggfXRkTiUEgQ', CAST(N'2025-05-12 05:55:46.9059590' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'9gh5u6r56f7913k44u2kxetbhidmgy1p', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9StT:uJT_4BH10aJR4kbZaPHay1ZEGkRV2s0_k5KvY4z15JM', CAST(N'2025-05-12 21:07:51.3103040' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'9l1igz0ovwqdp6pxj0059r06rbgu6035', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u7xgs:cYRJRD61AgAEClVTUDOp6OitARsr2bW2aiEF1G8QHeU', CAST(N'2025-05-08 16:36:38.5968060' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'9qmz90n1g067daqv48y7kt9ph0vryc05', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u9ad1:rwrxqmIXJcEiDwIAPU7y70YvTkzi1zNMncXuhE_BgW0', CAST(N'2025-05-13 05:23:23.8245830' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'9t007rwrc3t5whxebd29f842b2wvhtjh', N'.eJxVjEEOwiAQRe_C2pApUIe6dO8ZyMwAUjU0Ke3KeHfbpAvdvvf-f6tA61LC2tIcxqguquvU6RcyyTPV3cQH1fukZarLPLLeE33Ypm9TTK_r0f4dFGplW7NDawEJwCeD7GJ05F2Gc0aRxABobM_SZ2BjEXDwIkYINjLYnJ36fAH8-zgh:1u9diF:erfAqCfE60VIVc3u7FrG68TPT9hQjlcMNW35uo5i4uI', CAST(N'2025-05-13 08:40:59.1336050' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'a1vp2c2nj8du5koiq7upwgyr1y8krosy', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9bAE:5JHfUHWGBLkUNAzxz6t2_5_YkFQw66TlRQjsoAN0pLE', CAST(N'2025-05-13 05:57:42.4108770' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'a5p1h0klujail9ke0i20x9pgojui2raz', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8FGN:jlkK6_8J9f99xg3VxZ_rkedW4Rzw3NJPgzKQ7Qe0ia8', CAST(N'2025-05-09 12:22:27.1853320' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'agxih2yskz0y2pxzgcpg4noydrvsvvuk', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9bSj:na7pNigoZATCEHKD0sDBdOyDhPEiUZ7mNweSUg6nZEg', CAST(N'2025-05-13 06:16:49.2531570' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'aigi29axju4x7noail9m8sr7occz9tku', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9dKY:E_FwQgrIyGO8UCTTx0OGFjoSRcIB9_DWxcKsDsOpGt4', CAST(N'2025-05-13 08:16:30.5376610' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'apiigmtkaqk5iw4tzbh3e4yawd6dwv1k', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8Edg:lJUUeZxwDkSjcG-7khgF_3Q2iMgWQvamMG-n0G_LwnA', CAST(N'2025-05-09 11:42:28.7165050' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'aris650w7noxmusquyctyg51vw31ynvn', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8rJo:k9Oc81mfo7EcR3Q5oYkuNMzG-D2U2qauk7N_041lOzs', CAST(N'2025-05-11 05:00:32.7498230' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'b13d715ty36t3xw35awm28aokuw4wsey', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9ddK:C685zn3i3h4VZCQQBlaa4ByyqI5cjJ9mN3MeF1Rv5es', CAST(N'2025-05-13 08:35:54.6800640' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'b7ers5cuyyi7vx684vl327n3qapzrf5w', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8rOC:51c0-e3vGwCAAq5QjgznpkKVyEylQrXzME39xRHjVAM', CAST(N'2025-05-11 05:05:04.5689500' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'bj6towispi8zem5mxls8qsxsmhu9ufbr', N'.eJxVjEsOwiAUAO_C2hBe4fFx6b5nII8CUjWQlHZlvLsh6UK3M5N5M0_HXvzR0-bXyK4MJLv8wkDLM9Vh4oPqvfGl1X1bAx8JP23nc4vpdTvbv0GhXsZXaQqAItuUnYlBACSYSEWnpRDoggKpNNoJQFmXpTUqotbkUCbMBtnnC94SNo8:1u9dfF:VvgqMu3Nd4QFBsVH0GExZjYQkBRX2ahtLWdfwh_nKts', CAST(N'2025-05-13 08:37:53.3912840' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'bpg9vvg4sv3h1cdc42qt15n902z28m1y', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9dcj:ZUXXSWT3u4ZEY92oaVpUNVHJ_rdPlf1ubTtyTX35D6U', CAST(N'2025-05-13 08:35:17.7441350' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'bqkmdk3ileimd66idvbaaxv2fefmqpbo', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8VTB:SJe1KtfEXcyMYDx7fG6swhRdPWRmc8DxRcjzQdF9x-M', CAST(N'2025-05-10 05:40:45.3865370' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'bqsb5z9etl3codod3istcc6cznx83xqe', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9a24:1UKFWBVeSovX4yp2cZzq83lpmoKKVtNn6gtYr2_soBU', CAST(N'2025-05-13 04:45:12.2880210' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'brkvkg1nvk5nu4j125e0wujrgf4lh5s8', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9DQT:rn5LZkAOGCImZGcoMOrDK4ZK6-UzjVjlRuTgOpgbiyI', CAST(N'2025-05-12 04:36:53.0714010' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'cu6pkds7mbi5g2803qu1pv1jpx1dwbof', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9DXp:j_TNb4hXshnmQW3DXa8lT0i664MxKc07hS767tI6XAc', CAST(N'2025-05-12 04:44:29.1793350' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'cxpospwxpnif49yjuskt5ihd6hfhvppk', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u7ycH:S0Ro2CqCxjNBgEAsbtqj40l2CTWLXPkvKYW9n3kV6nA', CAST(N'2025-05-08 17:35:57.8106520' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ddt1k97afu373zdd8145qx0htp59stjw', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9chp:gFB-9jttDPWTYVLCBQUwsyTwJZVYtNJe4SlfyD28PxY', CAST(N'2025-05-13 07:36:29.8837070' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'dex3wtw04az81qa3jfdude7auy4lcrig', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9YV1:Rp75e65g-DinRgPyIPs21E8rVXdAlqJjRBZppUKqgeo', CAST(N'2025-05-13 03:06:59.6567890' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'dydya2vk7d80pxjvz4mnpdl9td407jv1', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9DUl:JHDtmPh8Z8UqiLHxJjIhyY9tzkljCE806_KbW1J8UII', CAST(N'2025-05-12 04:41:19.1039470' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'dz8260zamnk5hbqakdgkmzqfzmzfmc86', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8Zjm:S3_zT5jxKQ2uO-B0Xy9wK0o64RWjyq3rpr0pR1lVvSM', CAST(N'2025-05-10 10:14:10.8140280' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ethfvfphmmmp02psoylj8qi5cb9ik20x', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8VVb:YMDwW3kv1BWbhpSC-Ws6Om0u598a715VeZtJ128JGqs', CAST(N'2025-05-10 05:43:15.1987340' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'f8iqri7s750y178k3yy4uyf5mqpezno1', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u81E2:Gk1E0yE4S9Eu51dGHNH-r5h3y9XrsAwHMMs7DAkR-Wg', CAST(N'2025-05-08 20:23:06.2815640' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'fbi504oyq4j775n1j2vhtp4c4d0jp995', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9D6E:CHqH94Ht_z8AJLKrui_KQ1_ydMaMZxzROptKQFEBBv8', CAST(N'2025-05-12 04:15:58.2630420' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'fglr6r4yt08v2ocbj4brq8nba2segduw', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u9Fo7:hX4A5rDW2QoXC-hmVAknIsGJdT-Uw0vc6AY7aeZbHFY', CAST(N'2025-05-12 07:09:27.8443590' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'fl9c75i5k736wfw96wb09yr2mrj4bitq', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u746t:-k1NKTsUmKTQNyc1ANLGGUPP8PxBz7Qd81bj8aSoV9g', CAST(N'2025-05-06 05:15:47.5010360' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'fsmsctq1wq0xd6rjn18weyy1nuy1fppm', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9bbW:ugBAOgIUls5F7Tyv1yA6D4pcKhS4rUgND7K0Xp5dows', CAST(N'2025-05-13 06:25:54.9057160' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'fvrnyn3r1dekffzvnw5qnssa8ufoe8zy', N'.eJxVjMEOwiAQRP-FsyEUaFk8eu83EHYXpGpoUtqT8d9tkx70Npn3Zt4ixG0tYWtpCROLq-i0uPyWGOmZ6kH4Eet9ljTXdZlQHoo8aZPjzOl1O92_gxJb2deIlC1ZdNAhOKvIWG16QxoseEblmNgoTQMM2pgenPbsGP2eM7jM4vMF-_g3hg:1u9UBb:lRUBv_PbimW7b-mHM24hJ_uSHwZzW2XHKl9dd9xp_K4', CAST(N'2025-05-12 22:30:39.6139520' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'fzoinjjpgc5l7wsh5b6aozmklqaba778', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8nQB:LIGulgRZ78MXTK-PSfrqyZ5IF09RnlaE9PJEvnWBYaM', CAST(N'2025-05-11 00:50:51.9170880' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'g6xciujwgq0s2ynigyxoratuiij5y6rp', N'.eJxVjEEOwiAQRe_C2pBCJwgu3XsGMsMMUjWQlHZlvLtt0oVu33v_v1XEdSlx7TLHidVFjer0ywjTU-ou-IH13nRqdZkn0nuiD9v1rbG8rkf7d1Cwl22NYITAOo_eYchkzoFNYpPHbKwQZgIOQdD6gcURCGcgpryRAYwH9fkCDu05Sg:1u88fe:WRsH__Ki-6lZ8caPhUfz8OPexS-XTYvDyfFhLeC2Xmw', CAST(N'2025-05-09 05:20:06.4035770' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'g9w27f292rl80gy2vrjqoo0uq8qudl93', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u9Fs6:CgIszpHVMKXsmlQbWdsYbYwkHExxfqh8HQlquWePcHo', CAST(N'2025-05-12 07:13:34.9598680' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'gmv6zt732yi5augbjsftgrcfgf4mzar8', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8V0D:b6JlKFP39AeYG1NIOrR6gT5l9CUPjny7X_37B1MPQ9M', CAST(N'2025-05-10 05:10:49.0136720' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'grxo5racrteyrcipcdliel11eivoawr3', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9bFM:JXhb46d6ekB10YgX1yajstj7dibVDpiuWTOCzdf72C8', CAST(N'2025-05-13 06:03:00.2846160' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'gt9dxmam7xlxi2d0lkdfczws43qnpwed', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u756y:95KwyIZPwl0AVNSBC6cWFHFwzAEnkVofsIO9-8VVE7M', CAST(N'2025-05-06 06:19:56.5483380' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'gxlhgoz7qazyyba3ekpw5uxjttaxnfn2', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u96x8:tL9MwSOyXAQBisOUzLI3homVnxPpcAUVKLeLedlEKLA', CAST(N'2025-05-11 21:42:10.8284470' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'h016p78a6qmp0yyihfcqphh2tkj22wom', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8Bcz:qw54LcTf15IM0oUc7dkcljUyHkRTRsW0tXHXM5ZryzE', CAST(N'2025-05-09 08:29:33.9704260' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'h1r1sogfp1ve136qh2uaolcs449m7dcf', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9dJB:7tnjWy5OlfLwRVOh7ZMVV_vdsq1QvHUuZLjyqi7m4gs', CAST(N'2025-05-13 08:15:05.0776400' AS DateTime2))
GO
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'he4wrsz6q7olt4mprrvma8wy5f4kcf0g', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u74TD:J4NU3XjK0Vhg78cjh9cIrMvE_uHuD92AIH3CWLtA8f4', CAST(N'2025-05-06 05:38:51.0360660' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'hfa1czkx8b5s4h2zuqmwcfyivnd7emqa', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9YPU:PaNB5bzOXrVQBg32be-4sN0jHj034hDUk8Xo14kNre0', CAST(N'2025-05-13 03:01:16.7136510' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'hhiuhg3hfl7lhy2p0god34b8flskxlco', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u96jI:Zv8Ij3aCDs4enhxQNXV2LU2RM8Wl0Y_wl-XIzOG5zaw', CAST(N'2025-05-11 21:27:52.7036870' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'hmbmvncna1ionvubdp2bi4kq582wmij4', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9db3:6h94v7kqppNgQsgkWH22-EQBeFsG-8eHFaNGrHgIQLs', CAST(N'2025-05-13 08:33:33.2496040' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'hycf2d0ah5gpfsr4u0rng4ymb4p28u0w', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8QAj:L6ug5MRaO91OZjZlCu61xqRdALK_LK7uCuDZHMApun4', CAST(N'2025-05-10 00:01:21.9969520' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'i4mt0xh3hghq7cc2tkevpyss7fz5rbb9', N'.eJxVjEEOwiAQRe_C2hBgKIwu3XsGMjAgVUOT0q6Md7dNutDtf-_9twi0LjWsPc9hZHERXpx-t0jpmdsO-EHtPsk0tWUeo9wVedAubxPn1_Vw_w4q9brV1lh3dkVnLDZaNK44RAAevHNAkDQoLmAQVCQDKSuL7AdPWm-BYhafL7ltNuw:1u81PK:hdp18V6txzsqqqAlcNQb-vFjmOC570wP7IKzkM0yads', CAST(N'2025-05-08 20:34:46.7653090' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'i9s24sfc4licak21uwokfnbhwagm64i2', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u82QL:KO06ZU8ae0HkxiwOL0RFEWPt8I4zqbz2O7lWtOscaYs', CAST(N'2025-05-08 21:39:53.6969990' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'iqfrz55h98qh498wu26ubfgx7udgjvbo', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9bVx:bU2bgkyC0wdyi1dQH9X3_fVSV1ednKRvTZPf3LIFsAQ', CAST(N'2025-05-13 06:20:09.2996840' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'itsma2pu4rjvaeulcgq0jlhfwsjyy50t', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9a8y:jn-xnfoCBHgsAZmwLT2rOeDaG60yLv_Gdss6Cs518gc', CAST(N'2025-05-13 04:52:20.9769800' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'j950q2j7pecza7o4zd562ad5dk98ws4f', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8XP7:AsAOsxtuQwbsxsQrBrNF-84kbY9wZ8JK4VgVyUrdU_Q', CAST(N'2025-05-10 07:44:41.2093780' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jcm16tnjciklsqt7gohby0l87bv1iwir', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8R78:fLQYF1wtmAKrLKlTRX-bkDZV8appcOOvgiER3n1A1ss', CAST(N'2025-05-10 01:01:42.2541810' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jg8ld48c7s8hnc9v6velqsrs9va5a34s', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9adO:YoYCqcIisWKHnBdazHqDAWY6Pc9D5lQkur0ekxT3BLg', CAST(N'2025-05-13 05:23:46.6902200' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jic5j60yqq4c2ahcmpwfjau8w17jgr4g', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u77NK:HQmZmNcR5CZk85to2O1KUhZjF0LVhXIY9Y5N3BL5Ysk', CAST(N'2025-05-06 08:44:58.9570910' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jldw2vca26vv1nxmfebfttnx856of9bk', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9YOY:1RpP4y2gAu_LdXdl4nxG5ac1ATxtsJLMeosq2iMc5sM', CAST(N'2025-05-13 03:00:18.2575200' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jq3jg3i1dqdtbiyfux2knui0asxknqmj', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9lTB:qiZhKHbCdODWBvmTN7W3r3mFKkvubdQqHYYPsm2ORoY', CAST(N'2025-05-13 16:57:57.5483270' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jrr1701u5uoguggydd4me079bnv2fta9', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9Wev:50_Qp9879wwqT9Y9_CfEkc-LyREJ4UNwTLWq3vxUUK8', CAST(N'2025-05-13 01:09:05.9553250' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jrtjsibv24geu8763xnodl9gzodusei5', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u9FPi:BL1-yv86ZJEM7sCZQmd-S68aD8eiHmUVIpTR0m5pHfg', CAST(N'2025-05-12 06:44:14.5440460' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jsme2xlth29r88g7xvhu8svpu3dzs4tv', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u9Ssy:94Pp96nGWVp1NjNwcXY3d9JHP-uxMW36YAD7SyPO0rg', CAST(N'2025-05-12 21:07:20.8300500' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'jxm1hnetqq2b1vo4a4koo75l15n751le', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9Ed2:9EEx9pC0Zu3Z8xpxFxfdKdc1drlxfPDNP01khkhkIPo', CAST(N'2025-05-12 05:53:56.0128660' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'kay64v90p897hvk1w0xpwj4pxb4c4gez', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8lxu:XlX9VKENzi4Nxil21j4mYTDtxMgjPifoMF0CXQxNsCg', CAST(N'2025-05-10 23:17:34.3819910' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'kj57oba52vbx96061s143ubbg5kqth1i', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u8Abn:ea3XvR_LA34DJ-v4KqjTm7yD2JFM5aITyVDmWLmInKU', CAST(N'2025-05-09 07:24:15.5677840' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'kjbixkmv4cr9jsp6qj53b5ov4u5ynpv9', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1uA6p9:tvwP0_Ewo_T497LhNSjNusHgWcZgTMZisEQ2dcke7f0', CAST(N'2025-05-14 15:46:03.8000880' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'kny8ij2lli5wef7bdxiectmnvg9cexz3', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8XGj:PgmnkPTfdlgLwE6xxyUzbNnnpic99sAeS4arrp8XEW8', CAST(N'2025-05-10 07:36:01.0873590' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'kotc1pe324jouxov34q7evv9yrn7oqfv', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u74Lq:a_Tp_bFAgHz-jgdcIlXkZSHmloY6Qt1DErZcI6jOCQ0', CAST(N'2025-05-06 05:31:14.7813700' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'kujaksd0wvjumuqnu096jpbs4sdcreeu', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u82uX:NEdem96wY-VCBS-9FoIEKjcqRFJ_EfyiLE1-D3iBaro', CAST(N'2025-05-08 22:11:05.8111420' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'l5k5w1ajlj2lwbsabtfk96qxnp5edfe0', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9dkp:ZkLepW_7LXOhpgAFq5TIkmxEoKCl2FLup7CaYtDKCZg', CAST(N'2025-05-13 08:43:39.0293660' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'l66c8bm8pee3g8wl2t6ik2usp7jcbtza', N'.eJxVjMsOwiAQRf-FtSE8plNw6b7fQAYYpWogKe3K-O_apAvd3nPOfYlA21rC1nkJcxZnYcTpd4uUHlx3kO9Ub02mVtdljnJX5EG7nFrm5-Vw_w4K9fKttQKnELy1hEY7SApGjxH0wJAgsblm7azXLqoB2FiFY3ToMRNnk6IS7w-dQzar:1u4RkG:Ic3n9G5xkT0i4oJ4VbeNJgvW5oKrwXWFD8fjdKwnj9E', CAST(N'2025-04-28 23:53:36.5244360' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'lfqtfg3wanjhziwxokdgdcz8xscm3azx', N'.eJxVjEEOwiAQRe_C2hBgKIwu3XsGMjAgVUOT0q6Md7dNutDtf-_9twi0LjWsPc9hZHERXpx-t0jpmdsO-EHtPsk0tWUeo9wVedAubxPn1_Vw_w4q9brV1lh3dkVnLDZaNK44RAAevHNAkDQoLmAQVCQDKSuL7AdPWm-BYhafL7ltNuw:1u82kC:wD5Y9IPaydW4U84O08bjo_3UtK7-CAxo59-jSZ_vQQU', CAST(N'2025-05-08 22:00:24.7928630' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'lmr8uqayoyozjafslfk0ogt0ustdx4ln', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8Yve:nWc1l1R1m7Wt6B0Fg2-JAAxRcNXkq_BMdsi3tin6jk0', CAST(N'2025-05-10 09:22:22.9758070' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'losjjsq6l5zf3e0q8p7flicggtvvqoe9', N'.eJxVjEEOwiAQRe_C2pBCJwgu3XsGMsMMUjWQlHZlvLtt0oVu33v_v1XEdSlx7TLHidVFjer0ywjTU-ou-IH13nRqdZkn0nuiD9v1rbG8rkf7d1Cwl22NYITAOo_eYchkzoFNYpPHbKwQZgIOQdD6gcURCGcgpryRAYwH9fkCDu05Sg:1u869B:AIlQ-9Wgw_ujI2n9DLfrMBajOy3F_3jzq6KZajNwEJI', CAST(N'2025-05-09 02:38:25.4856150' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ly7j9gdi3q1xrl3ew73iisxipe5qv9uy', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8rJ5:erPDhu89OTgnWBpELZIIiMpFkukxATBPqrZRPPms1Gc', CAST(N'2025-05-11 04:59:47.7701750' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ma7liqavbyjq0985jr163bojjvwwer9v', N'.eJxVjMEOwiAQRP-FsyEUaFk8eu83EHYXpGpoUtqT8d9tkx70Npn3Zt4ixG0tYWtpCROLq-i0uPyWGOmZ6kH4Eet9ljTXdZlQHoo8aZPjzOl1O92_gxJb2deIlC1ZdNAhOKvIWG16QxoseEblmNgoTQMM2pgenPbsGP2eM7jM4vMF-_g3hg:1u9Z71:74NWQjEJ36TLik0QL-Or_w7dru-dAYe-_0y4jGqWgZM', CAST(N'2025-05-13 03:46:15.7468460' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'mfgj81z4prqnihz75cgzo77pkrrzj8mk', N'.eJxVjEEOwiAQRe_C2pApUIe6dO8ZyMwAUjU0Ke3KeHfbpAvdvvf-f6tA61LC2tIcxqguquvU6RcyyTPV3cQH1fukZarLPLLeE33Ypm9TTK_r0f4dFGplW7NDawEJwCeD7GJ05F2Gc0aRxABobM_SZ2BjEXDwIkYINjLYnJ36fAH8-zgh:1u9YHU:wzzIJm-oS1tfNjfqOpyAASmwDK1cRPMn-FbCZ5eT2pI', CAST(N'2025-05-13 02:53:00.6680470' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'mhql5oe41a7rpw1d4swyb2mq707x3n23', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9diY:-5v_ToWXDV8XFvc2WvXBgObo5PeRb8jMPdQk-rhVEcE', CAST(N'2025-05-13 08:41:18.0990990' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'mrne3j0d00utoh32ljqz5sxl2oos5dry', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u9Fat:grTy3WwEks7IYWo1j9e0pR3LB_aiLDyezZMfbFNl9CM', CAST(N'2025-05-12 06:55:47.3983260' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'mry31zc9d3ye737wdvm3j49jtrnh70vn', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9b2r:C9x_W6QKPkX-aoZCYuYiM1KBjFDAqLYjwnVwAlGlV5c', CAST(N'2025-05-13 05:50:05.6380230' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'mwxu2immsg8zi2dubglnc43zz1eg3uvy', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8jna:mtAc4xPl1m6sB8fBCfmEMvLXmFOlJmaf849iPs_npmM', CAST(N'2025-05-10 20:58:46.3561230' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'n3mzcmuncs01rm2n467ow8lv4rqxob0a', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9YuX:QxqfklHkxE6sacDDqCKPFL4FlH9_HgqRwQo0Ud_VlEg', CAST(N'2025-05-13 03:33:21.6099460' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'n4kmw9o1t9pz6s1tryykgxaffsi8memv', N'.eJxVjEEOwiAQRe_C2pBCJwgu3XsGMsMMUjWQlHZlvLtt0oVu33v_v1XEdSlx7TLHidVFjer0ywjTU-ou-IH13nRqdZkn0nuiD9v1rbG8rkf7d1Cwl22NYITAOo_eYchkzoFNYpPHbKwQZgIOQdD6gcURCGcgpryRAYwH9fkCDu05Sg:1u9FHk:7815UrpYIgrZJMPj5GvtKF2Fk0KkbmG0BRRcsMVhcq0', CAST(N'2025-05-12 06:36:00.1085830' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'n4xmx4u03vi235dbr0q1938cqsyns9hf', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8VNw:jMqKtBaC_KeM6I3Gw9FAkuC1APjmi_nKbdtdezt9-RI', CAST(N'2025-05-10 05:35:20.4691660' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'nbq1wl5coppcoqigukb3e0ccofar3ee4', N'.eJxVjMEOwiAQRP-FsyEUaFk8eu83EHYXpGpoUtqT8d9tkx70Npn3Zt4ixG0tYWtpCROLq-i0uPyWGOmZ6kH4Eet9ljTXdZlQHoo8aZPjzOl1O92_gxJb2deIlC1ZdNAhOKvIWG16QxoseEblmNgoTQMM2pgenPbsGP2eM7jM4vMF-_g3hg:1u9dpQ:Dht7D8e-0AYMT-zQaxv7dL6gJHbstTQgBZOJqMrsW9w', CAST(N'2025-05-13 08:48:24.7088540' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'nc49lw0r7al7hdyh4g0jg46snev4a94p', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u89OT:sa1zCZfPl2K83rW_LSjOdll8RpxA698nSB056VkH3l4', CAST(N'2025-05-09 06:06:25.3902020' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'nhp97hkx07u93mml4rdzh62q4r5abg8y', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8rXi:47vdtIu5PQAhDS5-ixsYEd5FpsgA8sn-KozLMZm5o3g', CAST(N'2025-05-11 05:14:54.2588940' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'nwgrp414ydg1oxctwkloteh7xwb2lii4', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9EoI:lPEJk4wu_21N74HvZGnLbtqcMxPX1xxYgrPGrWDfyCY', CAST(N'2025-05-12 06:05:34.8367680' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'o1txaiq3fkd35lobm24c1tq4kzhi8eyq', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u9Egb:ksme4VcL9r3dJPitv8dXR0F54uDUGlp4v_Re8_bbkZE', CAST(N'2025-05-12 05:57:37.9012230' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'od5px57slxm4erj1c1difl8j917zxw4x', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9DaQ:OxhqNSToArNRZ09m7zUCEFpfWkeESRpO5DG5EigDt00', CAST(N'2025-05-12 04:47:10.0685880' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ofds1oqi39kh0dhi9bpoas18aep3pycx', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9dIB:v6AgiNDxhEPZtyDoGqGmLblg1kRXn7kLRAjcCelnG1Y', CAST(N'2025-05-13 08:14:03.7124330' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ofewa1qvauxdltwz69vvjo3rgseupr1u', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u7xDZ:JvD0M0zNNyL9ZK7F7Q4Yqk1FyozqNO9_sopPH0tD_QE', CAST(N'2025-05-08 16:06:21.8002370' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'otmh3ckynp46opednjn0oupxmxbddo37', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8XFn:KqMpx4sqdKNW1saPyTjEjWprF-QR7U2O0btAYYeJMLM', CAST(N'2025-05-10 07:35:03.2191520' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'oymipetv65fadrdgc81lkdzulia9c06d', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9dXt:OdVMDkTr-Ds4-4sES5d_3zU53rk9i8R8ez9MQhB68dg', CAST(N'2025-05-13 08:30:17.0617850' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'p1zv1wxi6cof3c897yeuxsvt0vxz8jla', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u7xsZ:jjW7bPzNyhqPKe57R8k7ubW3RuF6qEn_BOi2I1IgMQs', CAST(N'2025-05-08 16:48:43.8099380' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'pbna67dbiit6f0syn1gpaesf26bgp59d', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9a0h:sR0UQRbEovChx6CLTFvTY5hm05A4U-IIq5xPEs56MzU', CAST(N'2025-05-13 04:43:47.7038810' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ph9akn2asg6uomid10s9f00scs4h6gi8', N'.eJxVjMEOwiAQRP-FsyEUaFk8eu83EHYXpGpoUtqT8d9tkx70Npn3Zt4ixG0tYWtpCROLq-i0uPyWGOmZ6kH4Eet9ljTXdZlQHoo8aZPjzOl1O92_gxJb2deIlC1ZdNAhOKvIWG16QxoseEblmNgoTQMM2pgenPbsGP2eM7jM4vMF-_g3hg:1u9det:iAw8Lmx5vPPqvDLjREPKN3kXS0l39GBYLqVFGtYNn0U', CAST(N'2025-05-13 08:37:31.0383210' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'pl3w5vad299xyauua7sms2prvr48aaws', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9dmQ:oC1_EiCdKiJ_MXTtPv0gYHrcxS3O91iI3L3HpPrOapI', CAST(N'2025-05-13 08:45:18.6376450' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'pospdj1ukm0v8y90xjtly4hav35zfbl8', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9cEL:lrvWVR0VKR39i5vHSpbB5t5aP8wEAVAmh6LZsJzEM4U', CAST(N'2025-05-13 07:06:01.5677570' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'pq54taztsn6tcb3mq6x3hl66041d5tl7', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9ZV5:PDl5Cz8yPPQOqc5iLk2lHdOBQa5e5eNK2IWWwAE3gfQ', CAST(N'2025-05-13 04:11:07.2381800' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'pzxmo792lq3dhld8pgm89l52mf58jdbw', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9Ybw:z-rHIz0IpC7bT_UKmsrYqYyBIsM8hcWPd4Nnl-dLd3s', CAST(N'2025-05-13 03:14:08.8950480' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'q4n1mzdevri2iblcbbkoej0lsmhpiuab', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9bRJ:QH2EnAjgIBaWfDcCFj1hR2RHxpY10z317V4CokpQK0Q', CAST(N'2025-05-13 06:15:21.1544050' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'qb79feovozky137n30y9x685izc1d3pm', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8rjV:vpUWrrssTB6Ki_P1uxV9nH8WPsjl8rzkGTb_wIZjwsg', CAST(N'2025-05-11 05:27:05.2943200' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'qc6tscudtuinsvuxftdxt1d2zo7cj9jo', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8rIo:IjtXNZnno4dfdLEE_wMHdivTaPQGjBq1AvONu1-4Kvk', CAST(N'2025-05-11 04:59:30.1159070' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'qjr7wd4z8xvwr943j1zekfvlyksp4mzn', N'.eJxVjEsOwiAUAO_C2hBe4fFx6b5nII8CUjWQlHZlvLsh6UK3M5N5M0_HXvzR0-bXyK4MJLv8wkDLM9Vh4oPqvfGl1X1bAx8JP23nc4vpdTvbv0GhXsZXaQqAItuUnYlBACSYSEWnpRDoggKpNNoJQFmXpTUqotbkUCbMBtnnC94SNo8:1u9Z5M:TM9g_u3U81VBvC0E0-7Y-CoZys3JLgIHu6qWrynZGm4', CAST(N'2025-05-13 03:44:32.6609080' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'qmvlgdptzhdtu59bi7meba2frs53yf7j', N'.eJxVjMEOwiAQRP-FsyEUaFk8eu83EHYXpGpoUtqT8d9tkx70Npn3Zt4ixG0tYWtpCROLq-i0uPyWGOmZ6kH4Eet9ljTXdZlQHoo8aZPjzOl1O92_gxJb2deIlC1ZdNAhOKvIWG16QxoseEblmNgoTQMM2pgenPbsGP2eM7jM4vMF-_g3hg:1u9ldd:ZdS6jLI2MDaZxxIhsxC-v5nGpSjpRi0BYVPrkpSAlq8', CAST(N'2025-05-13 17:08:45.1842760' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'qwv6xre2uo3c9g1im0n9tbgbya2ovf0h', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9Xkl:3Opf89LlnKJKYIigPwy7H_BkNJIRblahMkTeVi-bji8', CAST(N'2025-05-13 02:19:11.7000620' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'r1nf879770w5uv4sgkxytqtnlaojffkb', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8YHm:s6AsS4jMjP5RaCnARlK9lSam7TxRC8XQoRwb51ir7wk', CAST(N'2025-05-10 08:41:10.0655250' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'r5capvtyt20c6vm6eyjv98vvd515lynd', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9Eg8:ATN1FNIboxOxIvUUDvXZWEY9MWZzRZFKeGOyZuqkP-E', CAST(N'2025-05-12 05:57:08.1602490' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'r7acglzaljejmxm6yk8xocywh60t0n5c', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8CtT:eMhQkVkiqEbQnd_Pe3VyxJGuR3GpeUhaJ-vkQXO9Gl4', CAST(N'2025-05-09 09:50:39.0604190' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'rik5wze9fzyr2b1c86mljfqpoi763p4l', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u8Yb7:6CxhS3j7VcTyk2fQ2nArYQkQv3lMsSUMzWWaaNbx95s', CAST(N'2025-05-10 09:01:09.8740470' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'rqjxeheb3naspp3nios1zdg1od1j05r4', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9Eac:5Dyt1qh5fXepow_4FquwgEuOYRObW8Q7gsVD2AFgSaM', CAST(N'2025-05-12 05:51:26.5446270' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'sd0mvlbelq2zw4j2td8gcfmtku7oesez', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9UNE:Xp9Vfr96R3u7gLVR_UGHOKCgXlHlymKParl-40sRocs', CAST(N'2025-05-12 22:42:40.3230090' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'sgyvznzq5d4f8fe4cwym71kofcq7bdz0', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9Wrz:st1mMxImMCJ9QWFTXukVue8criniaM3_DnYM6cSx3Ys', CAST(N'2025-05-13 01:22:35.3963130' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'sh7zgiok0agddpjo75rtn8t91hmz03au', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9eEu:RIboTCY7ASkmtX638jAUnq0pDqXsivSmIWkRVqPd_D8', CAST(N'2025-05-13 09:14:44.6860580' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'suxg29mbdgd30kblyt80lxnxzde51z03', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9Zyg:DKhO-A20Uw7BtCNCQLFuPMIg01-39WEJNrt-BylB4v0', CAST(N'2025-05-13 04:41:42.7152990' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'svu0e0ltvmwlsb8ptbahs6g4cqrvfvmr', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9EsJ:VPm1N5U7qj87N28bhrQEss3FwTn1xlKiZy5ZRr-5vC4', CAST(N'2025-05-12 06:09:43.2494050' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ti9njiazm0h5cleehp139txj6ypkwbkg', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u8Zfy:UpnSNSof4e_-5hA59fzT7LelFkd7CsB9XgoNjCsxEZY', CAST(N'2025-05-10 10:10:14.9403010' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'us3eee6xcaagqkedavzosrh9nqpqhp9e', N'.eJxVjDsOAjEMBe-SGkUxa-SEkp4zRLZjkQWUSPupEHeHlbaA9s3Me7nM61LzOtuUx-LODt3hdxPWh7UNlDu3W_fa2zKN4jfF73T2117sedndv4PKc_3WEYEip1OAYJJUkJSQbGATIR3QCusRY0kmCCwxBAEREwqaSgBw7w_uKzh6:1u7yxw:xZMLS4dZKpb2MWV4he6vF3V_fxYK3n_lKQWa6FSeISc', CAST(N'2025-05-08 17:58:20.1939060' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'v13sx1flkrtaassw39zslax8bbqpnhup', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u96Pz:r1yBaSe7Q_79NWbwwTnQo6ISD7vBVecvNrgMfNBJddM', CAST(N'2025-05-11 21:07:55.9886150' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'vg2xmy2zwpghw8yvqf601txbcsllpg5a', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9bp0:OQqHQwsehBv3dQ7jaVvAj0g5v-Bt51uCjW0Rhu7RNwA', CAST(N'2025-05-13 06:39:50.9459490' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'vizf1brlfizt5tz9irclbcy20lzujmbr', N'.eJxVjDsOwyAQBe9CHSHAfFOm9xnQwi7BSYQlY1dR7h4huUjaNzPvzSIce41Hpy0uyK5MCnb5HRPkJ7VB8AHtvvK8tn1bEh8KP2nn84r0up3u30GFXketNRkpSCkIOhGJrKTxUFzwQQYywqKziKXgpIoSlIC8ys74gmkyxbLPFw1qOKA:1u9Yxk:PRtf0xJz614usbuPlU8kvza8faeetvhEYwLNUGvqr3A', CAST(N'2025-05-13 03:36:40.0866260' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'vvh6bax42b9udoolxxc4p66xd48kipps', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9ZW7:X3VOz5L0tuV8YGqtwyxKVRbEQHpawbLRYOoLJ0U_Oy4', CAST(N'2025-05-13 04:12:11.6661720' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'w9qeb9mv40g12hcgrg3o7aljg8e50tts', N'.eJxVjMEOwiAQRP-FsyFbWKB49O43kIVFqRpISnsy_rtt0oMmc5r3Zt4i0LqUsPY8h4nFWQxWnH7LSOmZ6074QfXeZGp1macod0UetMtr4_y6HO7fQaFetrUFZ0AB2kRpS-ZRkzf2psG7QZsYCbT1I_pkkTKxQ4wpEypQTnnW4vMF_aY3yQ:1u9dWu:2MhGu8gX_hNSUQjPS_OobyuPW0sE4rTb7l-Hr8QmtxY', CAST(N'2025-05-13 08:29:16.7725560' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'wikm6xwcyawbjf2vikkrlwoduc24arbj', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u9Eil:dMR9YSaccTT37MMWp6ZelE7bfYr6Br2gKbdXCwXlBRI', CAST(N'2025-05-12 05:59:51.9012300' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'wt54yd010dcxh8rpne6jzzeajcipv08u', N'.eJxVjDsOwyAQBe9CHSHAfFOm9xnQwi7BSYQlY1dR7h4huUjaNzPvzSIce41Hpy0uyK5MCnb5HRPkJ7VB8AHtvvK8tn1bEh8KP2nn84r0up3u30GFXketNRkpSCkIOhGJrKTxUFzwQQYywqKziKXgpIoSlIC8ys74gmkyxbLPFw1qOKA:1u9Y0W:8QqLfOWPzVhwrFGAac71xg5G-3hpfBg3z0FECN11iKI', CAST(N'2025-05-13 02:35:28.7439250' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'wvgr4gishvnsxybr6kj7zlxuc2gcibdl', N'.eJxVjMsOwiAQRf-FtSHAMDxcuvcbyPCoVA0kpV0Z_12bdKHbe865LxZoW2vYRlnCnNmZOXb63SKlR2k7yHdqt85Tb-syR74r_KCDX3suz8vh_h1UGvVbe7RFupytR-fJOlQgSYD0kIxOWWsoWpGHItBZZUCBcmJKk0QyEcGw9weyZDZn:1u8AGX:Jouu0Hzo8J8jxshtc02VxqOExllD5aXtWNjiTVC-4H4', CAST(N'2025-05-09 07:02:17.9438320' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'wwohgjho92lqamloazllloqbjjvsea64', N'.eJxVjMsOwiAQRf-FtSHAMDxcuvcbyPCoVA0kpV0Z_12bdKHbe865LxZoW2vYRlnCnNmZOXb63SKlR2k7yHdqt85Tb-syR74r_KCDX3suz8vh_h1UGvVbe7RFupytR-fJOlQgSYD0kIxOWWsoWpGHItBZZUCBcmJKk0QyEcGw9weyZDZn:1u7F4C:8iaJvLQpAwkIGOfm8ODycdj8WLKOGono9szvYEY2HoU', CAST(N'2025-05-06 16:57:44.3317600' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'x5h4jeqefrh8dja700du5gqnnfzv0hn3', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9dY4:9ojdGXxp_Z-dK95q2Nq-QT6OIOM715_swdkxa6Wcgos', CAST(N'2025-05-13 08:30:28.1657620' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'x78x6hhmye8930umb6z62xtizvxy2sou', N'.eJxVjMsOgjAUBf-la9NYSmmvS_d8A-l9CWpoQmFl_HclYaHbMzPnZYa8reOwVVmGic3FBHP63TDTQ-Yd8D3Pt2KpzOsyod0Ve9Bq-8LyvB7u38GY6_itm9YBta6LBIGdZ02aoggqqqALAXxAD4lYtVVQEGI4dw3E2CRFVPP-APa_OMw:1u9Ebz:L32fCsIUi2Wp8tRhS7UhVmWiFVNh2sj17y7TPENgYWs', CAST(N'2025-05-12 05:52:51.2670540' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'xmqa3krbs10bapojqrj7h7rom35sfhnz', N'.eJxVjEEOwiAQRe_C2hALhAGX7j0DmRlGqRpISrtqvLtt0oVu_3v_rSrhMpe0dJnSmNVFRXX63Qj5JXUH-Yn10TS3Ok8j6V3RB-361rK8r4f7FyjYy_a2JDmaEAgciLeDeIgO5c5B7FbJBqzDgTOjC46IyQoD-nhmsD6YqD5fBY84pw:1u9Xov:vjm1JieBGTvxp9yTKdqALAFCMaDk5XgASu12G5PAQkY', CAST(N'2025-05-13 02:23:29.9136740' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'xmzd6k0xp7ha181o0p6bjfr6cmt7umkv', N'.eJxVjEEOwiAQRe_C2hBgWkSX7j0DmWEGqRpISrsy3l2bdKHb_977LxVxXUpcu8xxYnVWQR1-N8L0kLoBvmO9NZ1aXeaJ9KbonXZ9bSzPy-7-HRTs5Vtb5mSOBJglOOQsDj14D4QhpDEwsOMBnc9ZkjMJbRg98gkoWzDkBvX-ABiYOOE:1u79tI:G6CvZmewE6DbqLAEbU833_RfAdAwF_Y4uL1fDZUmStI', CAST(N'2025-05-06 11:26:08.5106920' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'y66nervhhxu3prtaichmyhfqlcxqvv73', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9Z9E:BRPl4nL4JkJN-cTC_zOut89ZlDmhqKJcShq2ob1CFng', CAST(N'2025-05-13 03:48:32.2713310' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'yc5nghcr81u0xcr3zcs1oq2or4ri2cp3', N'.eJxVjDkOwjAUBe_iGlnfdrxASc8ZrL8YHECOFCcV4u4QKQW0b2beS2Vcl5rXXuY8ijop49XhdyTkR2kbkTu226R5ass8kt4UvdOuL5OU53l3_w4q9vqtrxjJF8cDBB8SQiAwLAaiQ-eKYRiOAkIuBQeBA6QINqFnX6w3RFa9P_ePN08:1u9ccR:3_0IKHEzyQPrPwFro0jdHbwIab2k5_vgsJazWZrfbcI', CAST(N'2025-05-13 07:30:55.6303380' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'yecb41d1a3veiybow01r2bn8cyqgzpxq', N'.eJxVjEEOwiAQRe_C2hCwDHRcuu8ZyMCAVA0kpV0Z765NutDtf-_9l_C0rcVvPS1-ZnERgzj9boHiI9Ud8J3qrcnY6rrMQe6KPGiXU-P0vB7u30GhXr712cbMiIZNJtQAOI4uUeSIQKAdqaytpgyYrNKaOZohOwwMCpRBzOL9Ae4kN-4:1u5qLz:9Jc4kbWdMmpUuVdAYZv-cUVIeglS-1MOkxPChkXBOqM', CAST(N'2025-05-02 20:22:19.0348950' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'ygrj3vatqsejjioo9buuzm86sx9zhei0', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9dXX:R8nQCtoLtvs6Lp1_k-p2-iOmdjM7eQI4m1caqi-hYXY', CAST(N'2025-05-13 08:29:55.9656330' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'yo8vaceruyoz5q9lpnww7f2rzq0mv6hx', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u74AE:RCDT-GulO1HIw5F7zOFScoVUFdT_ZoASWjG-nFQkbtk', CAST(N'2025-05-06 05:19:14.4338630' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'yz1ol2k96378l7h262yf1dx0yy925vl9', N'.eJxVjEEOwiAQRe_C2pBCJwgu3XsGMsMMUjWQlHZlvLtt0oVu33v_v1XEdSlx7TLHidVFjer0ywjTU-ou-IH13nRqdZkn0nuiD9v1rbG8rkf7d1Cwl22NYITAOo_eYchkzoFNYpPHbKwQZgIOQdD6gcURCGcgpryRAYwH9fkCDu05Sg:1u79Yo:SksHxmarDwjDjlI_EHZPebAdeh7ns4Aff0010DS3wu8', CAST(N'2025-05-06 11:04:58.6656480' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'z3g66kgmkjqxzbz1gysko8xry9g8stu7', N'.eJxVjDsOwyAQBe9CHSHAfFOm9xnQwi7BSYQlY1dR7h4huUjaNzPvzSIce41Hpy0uyK5MCnb5HRPkJ7VB8AHtvvK8tn1bEh8KP2nn84r0up3u30GFXketNRkpSCkIOhGJrKTxUFzwQQYywqKziKXgpIoSlIC8ys74gmkyxbLPFw1qOKA:1u9Z4q:tcKtFAGvwbHM0MS75lZiJJrjM87gCjjoR32OAD5FVf0', CAST(N'2025-05-13 03:44:00.8307330' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'z3vir2i17fl926sn9mcspkz6nid4qrhy', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9ZDD:33ZsbufOlv9aU2SuoeidR7U32_kjD4MBcTvm-NVn2Vs', CAST(N'2025-05-13 03:52:39.9072930' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'z5w9qjp3n532dsdz2pgiqfozyd99213t', N'.eJxVjDsOwjAQRO_iGlm2179Q0nMGa71ecAA5UpxUiLuTSCmgnHlv5i0SrktNa-c5jUWchbbi9FtmpCe3nZQHtvskaWrLPGa5K_KgXV6nwq_L4f4dVOx1WzMj66JvkRxHbULIUZFRfkAEp2hgMNaa7LzPVpUAgXBLQAogsLUgPl8NrzeR:1u9b8V:P8fPU6HkViuKe8IgCyxWtSof2shBQ-crTqGyxgYaUg8', CAST(N'2025-05-13 05:55:55.5175240' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'z91rcdc2wb0tmxsysqvow6wy1eocm6wl', N'.eJxVjDsOwjAQBe_iGlm7m8QfSnrOYK29NgkgR4qTCnF3iJQC2jcz76UCb-sYtpaXMIk6K6NOv1vk9Mh1B3Lnept1muu6TFHvij5o09dZ8vNyuH8HI7fxW5eMgwVxfYRkumgxJ--LM24gDz2Bt4R5oIIsxvUdEGCxZBgIsYCIen8AwnA2qQ:1u7yV1:RAHwpSzMtSSjizP_VTLu-r3DunqaZu327TlkJQ25UP8', CAST(N'2025-05-08 17:28:27.0140100' AS DateTime2))
INSERT [dbo].[django_session] ([session_key], [session_data], [expire_date]) VALUES (N'zu50npvifzf6s2bv071drp7pphq01lvx', N'.eJxVjEEOwiAQRe_C2hCwDHRcuu8ZyMCAVA0kpV0Z765NutDtf-_9l_C0rcVvPS1-ZnERgzj9boHiI9Ud8J3qrcnY6rrMQe6KPGiXU-P0vB7u30GhXr712cbMiIZNJtQAOI4uUeSIQKAdqaytpgyYrNKaOZohOwwMCpRBzOL9Ae4kN-4:1u78jm:szpDjCEquvtpA2Zu30CYoM2gE8LVHGapgIPuFqDPic0', CAST(N'2025-05-06 10:12:14.1153000' AS DateTime2))
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__api_user__AB6E61643FD53F52]    Script Date: 01/05/2025 03:30:40 ص ******/
ALTER TABLE [dbo].[api_user] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__api_user__F3DBC572106D52BA]    Script Date: 01/05/2025 03:30:40 ص ******/
ALTER TABLE [dbo].[api_user] ADD UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [auth_group_name_a6ea08ec_uniq]    Script Date: 01/05/2025 03:30:40 ص ******/
ALTER TABLE [dbo].[auth_group] ADD  CONSTRAINT [auth_group_name_a6ea08ec_uniq] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__authtoke__B9BE370E6E2BDB4A]    Script Date: 01/05/2025 03:30:40 ص ******/
ALTER TABLE [dbo].[authtoken_token] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[api_application]  WITH CHECK ADD  CONSTRAINT [api_application_job_id_ba24c1b4_fk_api_job_id] FOREIGN KEY([job_id])
REFERENCES [dbo].[api_job] ([id])
GO
ALTER TABLE [dbo].[api_application] CHECK CONSTRAINT [api_application_job_id_ba24c1b4_fk_api_job_id]
GO
ALTER TABLE [dbo].[api_application]  WITH CHECK ADD  CONSTRAINT [api_application_jobseeker_id_1f85884e_fk_api_jobseeker_user_id] FOREIGN KEY([jobseeker_id])
REFERENCES [dbo].[api_jobseeker] ([user_id])
GO
ALTER TABLE [dbo].[api_application] CHECK CONSTRAINT [api_application_jobseeker_id_1f85884e_fk_api_jobseeker_user_id]
GO
ALTER TABLE [dbo].[api_job]  WITH CHECK ADD  CONSTRAINT [api_job_recruiter_id_b0551201_fk_api_recruiter_user_id] FOREIGN KEY([recruiter_id])
REFERENCES [dbo].[api_recruiter] ([user_id])
GO
ALTER TABLE [dbo].[api_job] CHECK CONSTRAINT [api_job_recruiter_id_b0551201_fk_api_recruiter_user_id]
GO
ALTER TABLE [dbo].[api_jobseeker]  WITH CHECK ADD  CONSTRAINT [api_jobseeker_user_id_7fa64a84_fk_api_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[api_user] ([id])
GO
ALTER TABLE [dbo].[api_jobseeker] CHECK CONSTRAINT [api_jobseeker_user_id_7fa64a84_fk_api_user_id]
GO
ALTER TABLE [dbo].[api_recruiter]  WITH CHECK ADD  CONSTRAINT [api_recruiter_user_id_b307185f_fk_api_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[api_user] ([id])
GO
ALTER TABLE [dbo].[api_recruiter] CHECK CONSTRAINT [api_recruiter_user_id_b307185f_fk_api_user_id]
GO
ALTER TABLE [dbo].[api_user_groups]  WITH CHECK ADD  CONSTRAINT [api_user_groups_group_id_3af85785_fk_auth_group_id] FOREIGN KEY([group_id])
REFERENCES [dbo].[auth_group] ([id])
GO
ALTER TABLE [dbo].[api_user_groups] CHECK CONSTRAINT [api_user_groups_group_id_3af85785_fk_auth_group_id]
GO
ALTER TABLE [dbo].[api_user_groups]  WITH CHECK ADD  CONSTRAINT [api_user_groups_user_id_a5ff39fa_fk_api_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[api_user] ([id])
GO
ALTER TABLE [dbo].[api_user_groups] CHECK CONSTRAINT [api_user_groups_user_id_a5ff39fa_fk_api_user_id]
GO
ALTER TABLE [dbo].[api_user_user_permissions]  WITH CHECK ADD  CONSTRAINT [api_user_user_permissions_permission_id_305b7fea_fk_auth_permission_id] FOREIGN KEY([permission_id])
REFERENCES [dbo].[auth_permission] ([id])
GO
ALTER TABLE [dbo].[api_user_user_permissions] CHECK CONSTRAINT [api_user_user_permissions_permission_id_305b7fea_fk_auth_permission_id]
GO
ALTER TABLE [dbo].[api_user_user_permissions]  WITH CHECK ADD  CONSTRAINT [api_user_user_permissions_user_id_f3945d65_fk_api_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[api_user] ([id])
GO
ALTER TABLE [dbo].[api_user_user_permissions] CHECK CONSTRAINT [api_user_user_permissions_user_id_f3945d65_fk_api_user_id]
GO
ALTER TABLE [dbo].[auth_group_permissions]  WITH CHECK ADD  CONSTRAINT [auth_group_permissions_group_id_b120cbf9_fk_auth_group_id] FOREIGN KEY([group_id])
REFERENCES [dbo].[auth_group] ([id])
GO
ALTER TABLE [dbo].[auth_group_permissions] CHECK CONSTRAINT [auth_group_permissions_group_id_b120cbf9_fk_auth_group_id]
GO
ALTER TABLE [dbo].[auth_group_permissions]  WITH CHECK ADD  CONSTRAINT [auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id] FOREIGN KEY([permission_id])
REFERENCES [dbo].[auth_permission] ([id])
GO
ALTER TABLE [dbo].[auth_group_permissions] CHECK CONSTRAINT [auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id]
GO
ALTER TABLE [dbo].[auth_permission]  WITH CHECK ADD  CONSTRAINT [auth_permission_content_type_id_2f476e4b_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[auth_permission] CHECK CONSTRAINT [auth_permission_content_type_id_2f476e4b_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[authtoken_token]  WITH CHECK ADD  CONSTRAINT [authtoken_token_user_id_35299eff_fk_api_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[api_user] ([id])
GO
ALTER TABLE [dbo].[authtoken_token] CHECK CONSTRAINT [authtoken_token_user_id_35299eff_fk_api_user_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_content_type_id_c4bce8eb_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_content_type_id_c4bce8eb_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_user_id_c564eba6_fk_api_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[api_user] ([id])
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_user_id_c564eba6_fk_api_user_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_action_flag_a8637d59_check] CHECK  (([action_flag]>=(0)))
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_action_flag_a8637d59_check]
GO
