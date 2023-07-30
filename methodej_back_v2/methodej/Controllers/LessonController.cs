using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using methodej.Data;
using methodej.Models;
using methodej.DTOs;

namespace methodej.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LessonController : ControllerBase
    {
        private readonly MethodejDBContext _context;

        public LessonController(MethodejDBContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Lesson>>> GetLessons()
        {
            return await _context.Lessons.Include(l => l.Revisions).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Lesson>> GetLesson(int id)
        {
            var lesson = await _context.Lessons.Include(l => l.User).FirstOrDefaultAsync(l => l.LessonId == id);

            if (lesson == null)
            {
                return NotFound();
            }

            return lesson;
        }

        [HttpGet("user/{id}")]
        public async Task<ActionResult<IEnumerable<Lesson>>> GetLessonsByUserId(int id)
        {
            return await _context.Lessons.Include(l => l.Revisions).Where(c => c.User!.UserId.Equals(id)).ToListAsync();
        }

        [HttpGet("user/{id}/limit")]
        public async Task<ActionResult<IEnumerable<Lesson>>> GetLessonsByUserIdLimit(int id)
        {
            return await _context.Lessons.Include(l => l.Revisions).Where(c => c.User!.UserId.Equals(id)).Where(lesson => lesson.Revisions!.Any(revision =>
                revision.PlannedDate >= DateTime.Today.AddMonths(-3) &&
                revision.PlannedDate <= DateTime.Today.AddMonths(3)
            )).ToListAsync();
        }

        [HttpGet("user/{id}/countCreatedLessonCurrentMonth")]
        public async Task<ActionResult<int>> countCreatedLessonCurrentMonth(int id)
        {
            return await _context.Lessons.Where(c => c.User!.UserId.Equals(id)).Where(d => d.CreationDate.Month.Equals(DateTime.Now.Month)).CountAsync();
        }

        //Pour reporter une révision, on affiche un calendrier du moins avec des pastilles pour montrer quels jour on le plus de cours ect
        [HttpGet("user/{id}/countForReport")]
        public async Task<ActionResult<IEnumerable<int>>> countForReport(int id, DateTime date)
        {
            List<int> nombres = new List<int>();
            for (int i = 0; i < 32; i++)
            {
                nombres.Add(0);
            }
            await _context.Lessons.Include(l => l.Revisions).Where(c => c.User!.UserId.Equals(id)).Where(lesson => lesson.Revisions!.Any(revision =>
                revision.PlannedDate.Year == date.Year && revision.PlannedDate.Month == date.Month && revision.PlannedDate.Day >= date.Day
            )).ForEachAsync(less=>{
                foreach (Revision rev in less.Revisions!)
                {
                    nombres[rev.PlannedDate.Day]++;
                }
            });
            return nombres;
        }

        [HttpGet("user/{id}/countWithMinMaxDate/{min}/{max}")]
        public async Task<ActionResult<IEnumerable<int>>> GetCountCoursesByUserId(int id, int min, int max)
        {
            DateTime minDate = DateTime.Now.AddDays(min);
            DateTime maxDate = DateTime.Now.AddDays(max);
            
            List<int> nombres = new List<int>();
            for (int i = 0; i < 32; i++)
            {
                nombres.Add(0);
            }
            await _context.Lessons.Where(c => c.User!.UserId.Equals(id)).Where(lesson => lesson.Revisions!.Any(revision =>
                revision.PlannedDate >= minDate && revision.PlannedDate <= maxDate
            )).ForEachAsync(less=>{
                foreach (Revision rev in less.Revisions!)
                {
                    nombres[(rev.PlannedDate - minDate).Days+1]++;
                }
            });
            return nombres;

        }

        [HttpGet("user/{id}/search/{value}")]
        public async Task<ActionResult<IEnumerable<Lesson>>> search(int id,string value)
        {
            return await _context.Lessons.Where(c => c.User!.UserId.Equals(id)).Where(lesson =>
                lesson.Name != null && lesson.Name.ToLower().Contains(value.ToLower()) ||
                lesson.Matter != null && lesson.Matter.ToLower().Contains(value.ToLower())
            ).ToListAsync();
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutLesson(int id, EditLessonDto lesson)
        {
            var oldLesson = await _context.Lessons.Where(c => c.LessonId.Equals(id)).FirstOrDefaultAsync();
            if (oldLesson == null)
            {
                return NotFound();
            }

            oldLesson.Name = lesson.Name;
            oldLesson.Matter = lesson.Matter;
            oldLesson.LogoName = lesson.LogoName;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpPost]
        public async Task<ActionResult> PostLesson(CreateLessonDto lessonInput)
        {
            Lesson lesson = new Lesson();
            lesson.Name = lessonInput.Name;
            lesson.LogoName = lessonInput.LogoName;
            lesson.Matter = lessonInput.Matter;
            lesson.CreationDate = DateTime.Now;
            lesson.Revisions = lessonInput.Revisions;
            
            var user = await _context.Users.Where(c => c.UserId.Equals(lessonInput.UserId)).FirstOrDefaultAsync();
            if (user == null)
            {
                return BadRequest("User not found");
            }
            lesson.User = user;

            for (int i = 0; i < lessonInput.Revisions?.Count; i++)
            {
                Revision? rev = lessonInput.Revisions[i];
                _context.Revisions.Add(rev);
            }

            _context.Lessons.Add(lesson);
            await _context.SaveChangesAsync();
            return Ok(lesson.LessonId);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteLesson(int id)
        {
            var lesson = await _context.Lessons.FindAsync(id);
            if (lesson == null)
            {
                return NotFound();
            }

            _context.Lessons.Remove(lesson);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool LessonExists(int id)
        {
            return (_context.Lessons?.Any(e => e.LessonId == id)).GetValueOrDefault();
        }
    }
}
