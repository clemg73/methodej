using methodej.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace methodej.Data
{
    public partial class methodejDBContext : DbContext
    {
        public static readonly ILoggerFactory MyLoggerFactory = LoggerFactory.Create(builder => builder.AddConsole());
        
        public methodejDBContext(){}
        public methodejDBContext(DbContextOptions<methodejDBContext> options): base(options){}

        public virtual DbSet<Lesson> Lessons { get; set; } = null!;
        public virtual DbSet<Matter> Matters { get; set; } = null!;
        public virtual DbSet<Revision> Revisions { get; set; } = null!;
        public virtual DbSet<User> User { get; set; } = null!;

    }
}

