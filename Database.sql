/*
    IT43 - Secure Notes
    SQL Server database script

    The ASP.NET application can also create the database automatically
    with EF Core EnsureCreatedAsync(). This script is provided for
    manual creation / inspection in SQL Server Management Studio.
*/

IF DB_ID(N'SecureNotesDb') IS NULL
BEGIN
    CREATE DATABASE [SecureNotesDb];
END
GO

USE [SecureNotesDb];
GO

IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users
    (
        Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
        Username NVARCHAR(100) NOT NULL,
        Email NVARCHAR(320) NOT NULL,
        PasswordHash NVARCHAR(500) NOT NULL,
        CreatedAt DATETIME2 NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Users_Email' AND object_id = OBJECT_ID(N'dbo.Users'))
BEGIN
    CREATE UNIQUE INDEX IX_Users_Email ON dbo.Users(Email);
END
GO

IF OBJECT_ID(N'dbo.Notes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Notes
    (
        Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Notes PRIMARY KEY,
        Title NVARCHAR(200) NOT NULL,
        Content NVARCHAR(MAX) NOT NULL,
        CreatedAt DATETIME2 NOT NULL,
        UpdatedAt DATETIME2 NULL,
        UserId INT NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Notes_UserId' AND object_id = OBJECT_ID(N'dbo.Notes'))
BEGIN
    CREATE INDEX IX_Notes_UserId ON dbo.Notes(UserId);
END
GO

IF OBJECT_ID(N'dbo.NoteShares', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.NoteShares
    (
        Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_NoteShares PRIMARY KEY,
        NoteId INT NOT NULL,
        UserId INT NOT NULL,
        CanEdit BIT NOT NULL,
        SharedAt DATETIME2 NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_NoteShares_NoteId_UserId' AND object_id = OBJECT_ID(N'dbo.NoteShares'))
BEGIN
    CREATE UNIQUE INDEX IX_NoteShares_NoteId_UserId ON dbo.NoteShares(NoteId, UserId);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_NoteShares_UserId' AND object_id = OBJECT_ID(N'dbo.NoteShares'))
BEGIN
    CREATE INDEX IX_NoteShares_UserId ON dbo.NoteShares(UserId);
END
GO

PRINT N'SecureNotesDb is ready.';
GO
