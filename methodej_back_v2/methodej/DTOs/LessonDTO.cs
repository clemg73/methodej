using methodej.Models;

namespace methodej.DTOs
{
    public class CreateLessonDTO
    {
        public string? Name { get; set; }
        public int? MatterId { get; set; }
        public int? UserId { get; set; }
        public List<Revision>? Revisions { get; set; }
        public string? LogoName { get; set; }
    }
}
