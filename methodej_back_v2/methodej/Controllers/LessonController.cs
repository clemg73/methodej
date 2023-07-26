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
            return await _context.Lessons.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Lesson>> GetLesson(int id)
        {
            var lesson = await _context.Lessons.FindAsync(id);

            if (lesson == null)
            {
                return NotFound();
            }

            return lesson;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutLesson(int id, Lesson lesson)
        {
            if (id != lesson.LessonId)
            {
                return BadRequest();
            }

            _context.Entry(lesson).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!LessonExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpPost]
        public async Task<ActionResult> PostLesson(CreateLessonDTO lessonInput)
        {
            Lesson lesson = new Lesson();
            lesson.Name = lessonInput.Name;
            lesson.LogoName = lessonInput.LogoName;
            
            var user = await _context.Users.Where(c => c.UserId.Equals(lessonInput.UserId)).FirstOrDefaultAsync();
            if (user == null)
            {
                return BadRequest("User not found");
            }
            lesson.User = user;

            var matter = await _context.Matters.Where(c => c.MatterId.Equals(lessonInput.MatterId)).FirstOrDefaultAsync();
            if (matter == null)
            {
                return BadRequest("Matter not found");
            }
            lesson.Matter = matter;

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
            if (_context.Lessons == null)
            {
                return NotFound();
            }
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
