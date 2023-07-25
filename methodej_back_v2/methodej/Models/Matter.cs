using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace methodej.Models
{
    [Table("t_e_matter_mtr")]
    public partial class Matter
    {
        [Key]
        [Column("mtr_id")]
        public int MatterId { get; set; }

        [Required]
        [StringLength(30)]
        [Column("mtr_name")]
        public string? Name { get; set; }

    }
}
