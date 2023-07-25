using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace methodej.Models
{
    [Table("t_e_revision_rvs")]
    public partial class Revision
    {
        [Key]
        [Column("rvs_id")]
        public int RevisionId { get; set; }

        [Required]
        [Column("lsn_planned_date", TypeName = "date")]
        public DateTime? PlannedDate { get; set; }

        [Required]
        [Column("lsn_realized_date", TypeName = "date")]
        public DateTime? RealizedDate { get; set; }

    }




}
