using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace methodej.Models
{
    [Table("t_e_lesson_lsn")]
    public partial class Lesson
    {
        [Key]
        [Column("lsn_id")]
        public int LessonId { get; set; }

        [Required]
        [StringLength(30)]
        [Column("lsn_name")]
        public string? Name { get; set; }

        [Required]
        [Column("lsn_matter")]
        public Matter? Matter { get; set; }

        [Required]
        [Column("lsn_user")]
        public User? User { get; set; }

		[Required]
        [Column("lsn_revisions")]
        public List<Revision>? Revisions { get; set; }

		[Required]
        [Column("lsn_creation_date", TypeName = "date")]
        public DateTime CreationDate { get; set; }

        [Required]
        [StringLength(30)]
        [Column("lsn_logo_name")]
        public string? LogoName { get; set; }

    }




}
