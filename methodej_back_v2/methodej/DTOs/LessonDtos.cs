using methodej.Models;

namespace methodej.DTOs
{
    public class CreateLessonDto
    {
        public string? Name { get; set; }
        public string? Matter { get; set; }
        public int? UserId { get; set; }
        public List<Revision>? Revisions { get; set; }
        public string? LogoName { get; set; }
    }
    public class EditLessonDto
    {
        public string? Name { get; set; }
        public string? Matter { get; set; }
        public string? LogoName { get; set; }
    }
}
