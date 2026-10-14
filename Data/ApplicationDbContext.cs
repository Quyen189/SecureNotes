using AspNetMvcDemo.Models;
using Microsoft.EntityFrameworkCore;

namespace AspNetMvcDemo.Data;

/**
 * Represents the database context for the application.
 * This class is used to interact with the database using Entity Framework Core.
 */
public class ApplicationDbContext : DbContext
{
    /**
     * Initializes a new instance of the ApplicationDbContext class.
     * @param options The options to be used by the DbContext.
     */
    public ApplicationDbContext(
        DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<AppUser> Users { get; set; } = null!;
    public DbSet<Note> Notes { get; set; } = null!;
    public DbSet<NoteShare> NoteShares { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // SQL Server cannot create an index on nvarchar(max), so indexed
        // string columns are given explicit lengths.
        modelBuilder.Entity<AppUser>()
            .Property(u => u.Username)
            .HasMaxLength(100)
            .IsRequired();

        modelBuilder.Entity<AppUser>()
            .Property(u => u.Email)
            .HasMaxLength(320)
            .IsRequired();

        modelBuilder.Entity<AppUser>()
            .Property(u => u.PasswordHash)
            .HasMaxLength(500)
            .IsRequired();

        modelBuilder.Entity<AppUser>()
            .HasIndex(u => u.Email)
            .IsUnique();

        modelBuilder.Entity<Note>()
            .Property(n => n.Title)
            .HasMaxLength(200)
            .IsRequired();

        modelBuilder.Entity<Note>()
            .Property(n => n.Content)
            .HasColumnType("nvarchar(max)")
            .IsRequired();

        modelBuilder.Entity<NoteShare>()
            .HasIndex(s => new { s.NoteId, s.UserId })
            .IsUnique();

        modelBuilder.Entity<Note>()
            .HasIndex(n => n.UserId);

        modelBuilder.Entity<NoteShare>()
            .HasIndex(s => s.UserId);
    }
}