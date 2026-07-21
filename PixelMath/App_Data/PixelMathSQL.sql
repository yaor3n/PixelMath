USE master;
GO

-- ═════════════════════════════════════════════════════════════
-- 1. DROP AND RECREATE THE DATABASE (FRESH START)
-- ═════════════════════════════════════════════════════════════
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'PixelMath')
BEGIN
    ALTER DATABASE [PixelMath] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [PixelMath];
END
GO

CREATE DATABASE [PixelMath];
GO

USE [PixelMath];
GO

-- ═════════════════════════════════════════════════════════════
-- 2. CREATE TABLES
-- ═════════════════════════════════════════════════════════════
CREATE TABLE [Roles] (
  [RoleId] INT PRIMARY KEY IDENTITY(1, 1),
  [RoleName] VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE [Users] (
  [UserId] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
  [FullName] VARCHAR(100),
  [Email] VARCHAR(100) UNIQUE NOT NULL,
  [PasswordHash] VARCHAR(255),
  [RoleId] INT,
  [IsApproved] BIT DEFAULT 1,
  [CreatedAt] DATETIME DEFAULT GETDATE(),
  [Form] INT NULL
);
GO

CREATE TABLE [Classes] (
  [ClassId] INT PRIMARY KEY IDENTITY(1, 1),
  [ClassName] VARCHAR(100),
  [Description] VARCHAR(255),
  [CreatedBy] UNIQUEIDENTIFIER, 
  [CreatedAt] DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE [StudentClasses] (
  [StudentClassId] INT PRIMARY KEY IDENTITY(1, 1),
  [StudentId] UNIQUEIDENTIFIER, 
  [ClassId] INT,
  [EnrolledAt] DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE [Announcements] (
  [AnnouncementId] INT PRIMARY KEY IDENTITY(1, 1),
  [Title] VARCHAR(200),
  [Message] NVARCHAR(MAX),
  [ClassId] INT,
  [CreatedBy] UNIQUEIDENTIFIER, 
  [CreatedAt] DATETIME DEFAULT GETDATE(),
  [Status] BIT NOT NULL DEFAULT 0 -- 🎯 0 = Unread, 1 = Read
);
GO

-- 🎯 UPDATED RESOURCES TABLE WITH ALL REQUIRED COLUMNS
CREATE TABLE [Resources] (
  [ResourceId] INT PRIMARY KEY IDENTITY(1, 1),
  [ClassId] INT NOT NULL,
  [Title] NVARCHAR(200) NOT NULL,
  [Description] NVARCHAR(MAX) NULL,
  [ResourceType] NVARCHAR(50) NOT NULL,
  [FilePath] NVARCHAR(500) NOT NULL,
  [OriginalFileName] NVARCHAR(255) NOT NULL,
  [UploadedBy] UNIQUEIDENTIFIER NOT NULL,
  [UploadedAt] DATETIME DEFAULT GETDATE() NOT NULL
);
GO

CREATE TABLE [Quizzes] (
  [QuizId] INT PRIMARY KEY IDENTITY(1, 1),
  [Title] VARCHAR(200),
  [Description] VARCHAR(255),
  [ClassId] INT,
  [CreatedBy] UNIQUEIDENTIFIER, 
  [DurationMinutes] INT DEFAULT 15,
  [PassingMarks] INT DEFAULT 70,
  [CreatedAt] DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE [Questions] (
  [QuestionId] INT PRIMARY KEY IDENTITY(1, 1),
  [QuizId] INT,
  [QuestionText] NVARCHAR(MAX),
  [QuestionType] VARCHAR(20) DEFAULT 'Objective', -- 'Objective' or 'Subjective'
  [QuestionImageUrl] NVARCHAR(500) NULL,
  [Marks] INT NOT NULL DEFAULT 1
);
GO

CREATE TABLE [Options] (
  [OptionId] INT PRIMARY KEY IDENTITY(1, 1),
  [QuestionId] INT,
  [OptionText] NVARCHAR(MAX),
  [IsCorrect] BIT DEFAULT 0
);
GO

CREATE TABLE [QuizAttempts] (
  [AttemptId] INT PRIMARY KEY IDENTITY(1, 1),
  [QuizId] INT,
  [StudentId] UNIQUEIDENTIFIER, 
  [StartTime] DATETIME,
  [EndTime] DATETIME,
  [TimeTakenSeconds] INT,
  [Score] INT DEFAULT 0,
  [IsCompleted] BIT DEFAULT 0,
  [IsGraded] BIT DEFAULT 0 -- 0 = Pending Review, 1 = Fully Graded
);
GO

CREATE TABLE [StudentAnswers] (
  [AnswerId] INT PRIMARY KEY IDENTITY(1, 1),
  [AttemptId] INT,
  [QuestionId] INT,
  [SelectedOptionId] INT NULL,
  [AnswerText] NVARCHAR(MAX) NULL,
  [IsMarked] BIT DEFAULT 0,
  [MarksAwarded] INT NULL DEFAULT 0,
  [LecturerFeedback] NVARCHAR(MAX) NULL
);
GO

-- ═════════════════════════════════════════════════════════════
-- 3. ADD RELATIONSHIPS (FOREIGN KEYS)
-- ═════════════════════════════════════════════════════════════
ALTER TABLE [Users] ADD FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([RoleId]);
ALTER TABLE [Classes] ADD FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([UserId]);
ALTER TABLE [StudentClasses] ADD FOREIGN KEY ([StudentId]) REFERENCES [Users] ([UserId]);
ALTER TABLE [StudentClasses] ADD FOREIGN KEY ([ClassId]) REFERENCES [Classes] ([ClassId]);
ALTER TABLE [Announcements] ADD FOREIGN KEY ([ClassId]) REFERENCES [Classes] ([ClassId]);
ALTER TABLE [Announcements] ADD FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([UserId]);
ALTER TABLE [Resources] ADD FOREIGN KEY ([ClassId]) REFERENCES [Classes] ([ClassId]);
ALTER TABLE [Resources] ADD FOREIGN KEY ([UploadedBy]) REFERENCES [Users] ([UserId]);
ALTER TABLE [Quizzes] ADD FOREIGN KEY ([ClassId]) REFERENCES [Classes] ([ClassId]);
ALTER TABLE [Quizzes] ADD FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([UserId]);
ALTER TABLE [Questions] ADD FOREIGN KEY ([QuizId]) REFERENCES [Quizzes] ([QuizId]);
ALTER TABLE [Options] ADD FOREIGN KEY ([QuestionId]) REFERENCES [Questions] ([QuestionId]);
ALTER TABLE [QuizAttempts] ADD FOREIGN KEY ([QuizId]) REFERENCES [Quizzes] ([QuizId]);
ALTER TABLE [QuizAttempts] ADD FOREIGN KEY ([StudentId]) REFERENCES [Users] ([UserId]);
ALTER TABLE [StudentAnswers] ADD FOREIGN KEY ([AttemptId]) REFERENCES [QuizAttempts] ([AttemptId]);
ALTER TABLE [StudentAnswers] ADD FOREIGN KEY ([QuestionId]) REFERENCES [Questions] ([QuestionId]);
ALTER TABLE [StudentAnswers] ADD FOREIGN KEY ([SelectedOptionId]) REFERENCES [Options] ([OptionId]);
GO

-- ═════════════════════════════════════════════════════════════
-- 4. MASTER DATA SEEDING (ROLES)
-- ═════════════════════════════════════════════════════════════
SET IDENTITY_INSERT [Roles] ON;
INSERT INTO [Roles] ([RoleId], [RoleName]) VALUES 
(1, 'Student'),
(2, 'Lecturer'),
(3, 'Admin');
SET IDENTITY_INSERT [Roles] OFF;
GO