USE master;
GO

-- 1. DROP THE OLD DATABASE IF IT EXISTS
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'PixelMath')
BEGIN
    ALTER DATABASE [PixelMath] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [PixelMath];
END
GO

-- 2. CREATE AND SWITCH TO THE FRESH DB
CREATE DATABASE [PixelMath];
GO
USE [PixelMath];
GO

-- ═════════════════════════════════════════════════════════════
-- 3. CREATE TABLES (WITH UPDATED UUID / UNIQUEIDENTIFIER TYPES)
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
  [IsApproved] BIT DEFAULT 0,
  [CreatedAt] DATETIME DEFAULT GETDATE(),
  [EducationLevel] INT NULL
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
  [CreatedBy] UNIQUEIDENTIFIER, -- Matched to UUID
  [CreatedAt] DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE [Resources] (
  [ResourceId] INT PRIMARY KEY IDENTITY(1, 1),
  [Title] VARCHAR(200),
  [ResourceUrl] VARCHAR(500),
  [ClassId] INT,
  [UploadedBy] UNIQUEIDENTIFIER, 
  [CreatedAt] DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE [Quizzes] (
  [QuizId] INT PRIMARY KEY IDENTITY(1, 1),
  [Title] VARCHAR(200),
  [Description] VARCHAR(255),
  [ClassId] INT,
  [CreatedBy] UNIQUEIDENTIFIER, 
  [DurationMinutes] INT,
  [PassingMarks] INT,
  [CreatedAt] DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE [Questions] (
  [QuestionId] INT PRIMARY KEY IDENTITY(1, 1),
  [QuizId] INT,
  [QuestionText] NVARCHAR(MAX),
  [QuestionType] VARCHAR(20),
  [QuestionImageUrl] NVARCHAR(500) NULL 
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
  [Score] INT,
  [IsCompleted] BIT DEFAULT 0
);
GO

CREATE TABLE [StudentAnswers] (
  [AnswerId] INT PRIMARY KEY IDENTITY(1, 1),
  [AttemptId] INT,
  [QuestionId] INT,
  [SelectedOptionId] INT
);
GO

-- ═════════════════════════════════════════════════════════════
-- 4. ADD RELATIONSHIPS (FOREIGN KEYS)
-- ═════════════════════════════════════════════════════════════
ALTER TABLE [Users] ADD FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([RoleId]);
ALTER TABLE [Classes] ADD FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([UserId]);
ALTER TABLE [StudentClasses] ADD FOREIGN KEY ([StudentId]) REFERENCES [Users] ([UserId]);
ALTER TABLE [StudentClasses] ADD FOREIGN KEY ([ClassId]) REFERENCES [Classes] ([ClassId]);
ALTER TABLE [Announcements] ADD FOREIGN KEY ([ClassId]) REFERENCES [Classes] ([ClassId]);
ALTER TABLE [Announcements] ADD FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([UserId]);

-- FIXED: Fixed original typo here from 'R sources' back to 'Resources'
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

-- 5. STRUCTURAL MODIFICATIONS
ALTER TABLE [Users] ADD [Form] INT NULL; 
GO

-- ═════════════════════════════════════════════════════════════
-- 6. AUTOMATIC DATA SEEDING (MASTER SYSTEM ROLES)
-- ═════════════════════════════════════════════════════════════
SET IDENTITY_INSERT [Roles] ON;
INSERT INTO [Roles] ([RoleId], [RoleName]) VALUES 
(1, 'Student'),
(2, 'Lecturer'),
(3, 'Admin');
SET IDENTITY_INSERT [Roles] OFF;
GO