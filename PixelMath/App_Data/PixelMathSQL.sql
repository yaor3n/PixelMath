CREATE TABLE [Roles] (
  [RoleId] INT PRIMARY KEY IDENTITY(1,1),
  [RoleName] VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE [Users] (
  [UserId] INT PRIMARY KEY IDENTITY(1,1),
  [FullName] VARCHAR(100),
  [Email] VARCHAR(100) UNIQUE NOT NULL,
  [PasswordHash] VARCHAR(255),
  [RoleId] INT,
  [IsApproved] BIT DEFAULT 0,
  [CreatedAt] DATETIME DEFAULT GETDATE()
);

CREATE TABLE [Classes] (
  [ClassId] INT PRIMARY KEY IDENTITY(1,1),
  [ClassName] VARCHAR(100),
  [Description] VARCHAR(255),
  [CreatedBy] INT,
  [CreatedAt] DATETIME DEFAULT GETDATE()
);

CREATE TABLE [StudentClasses] (
  [StudentClassId] INT PRIMARY KEY IDENTITY(1,1),
  [StudentId] INT,
  [ClassId] INT,
  [EnrolledAt] DATETIME DEFAULT GETDATE()
);

CREATE TABLE [Announcements] (
  [AnnouncementId] INT PRIMARY KEY IDENTITY(1,1),
  [Title] VARCHAR(200),
  [Message] NVARCHAR(MAX), -- NVARCHAR(MAX) replaces text for better compatibility
  [ClassId] INT,
  [CreatedBy] INT,
  [CreatedAt] DATETIME DEFAULT GETDATE()
);

CREATE TABLE [Resources] (
  [ResourceId] INT PRIMARY KEY IDENTITY(1,1),
  [Title] VARCHAR(200),
  [ResourceUrl] VARCHAR(500),
  [ClassId] INT,
  [UploadedBy] INT,
  [CreatedAt] DATETIME DEFAULT GETDATE()
);

CREATE TABLE [Quizzes] (
  [QuizId] INT PRIMARY KEY IDENTITY(1,1),
  [Title] VARCHAR(200),
  [Description] VARCHAR(255),
  [ClassId] INT,
  [CreatedBy] INT,
  [DurationMinutes] INT,
  [PassingMarks] INT,
  [CreatedAt] DATETIME DEFAULT GETDATE()
);

CREATE TABLE [Questions] (
  [QuestionId] INT PRIMARY KEY IDENTITY(1,1),
  [QuizId] INT,
  [QuestionText] NVARCHAR(MAX), -- NVARCHAR(MAX) replaces text
  [QuestionType] VARCHAR(20)
);

CREATE TABLE [Options] (
  [OptionId] INT PRIMARY KEY IDENTITY(1,1),
  [QuestionId] INT,
  [OptionText] NVARCHAR(MAX), -- NVARCHAR(MAX) replaces text
  [IsCorrect] BIT DEFAULT 0 -- BIT replaces boolean
);

CREATE TABLE [QuizAttempts] (
  [AttemptId] INT PRIMARY KEY IDENTITY(1,1),
  [QuizId] INT,
  [StudentId] INT,
  [StartTime] DATETIME,
  [EndTime] DATETIME,
  [TimeTakenSeconds] INT,
  [Score] INT,
  [IsCompleted] BIT DEFAULT 0 -- BIT replaces boolean
);

CREATE TABLE [StudentAnswers] (
  [AnswerId] INT PRIMARY KEY IDENTITY(1,1),
  [AttemptId] INT,
  [QuestionId] INT,
  [SelectedOptionId] INT
);

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