using methodej.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace methodej.Data
{
    public partial class MethodejDBContext : DbContext
    {
        public static readonly ILoggerFactory MyLoggerFactory = LoggerFactory.Create(builder => builder.AddConsole());
        
        public MethodejDBContext(){}
        public MethodejDBContext(DbContextOptions<MethodejDBContext> options): base(options){}

        public virtual DbSet<Lesson> Lessons { get; set; } = null!;
        public virtual DbSet<Matter> Matters { get; set; } = null!;
        public virtual DbSet<Revision> Revisions { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;

    }
}

