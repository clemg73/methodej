using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace methodej.Models
{
    [Table("t_e_user_usr")]
    public partial class User
    {
        [Key]
        [Column("usr_id")]
        public int UserId { get; set; }

        [Required]
        [EmailAddress]
        [Column("usr_email")]
        public string? Email { get; set; }

        [Required]
        [Column("usr_password")]
        public string? Password { get; set; }

        [Required]
        [Column("usr_premium")]
        public bool Premium { get; set; }

		[Required]
        [Column("usr_creation_date", TypeName = "date")]
        public DateTime CreationDate { get; set; }

        [StringLength(50)]
        [Column("usr_study_program")]
        public string? StudyProgram { get; set; }
    }




}
