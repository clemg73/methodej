using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using methodej.Data;
using methodej.Models;

namespace methodej.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MatterController : ControllerBase
    {
        private readonly MethodejDBContext _context;

        public MatterController(MethodejDBContext context)
        {
            _context = context;
        }

        // GET: api/Matter
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Matter>>> GetMatters()
        {
          if (_context.Matters == null)
          {
              return NotFound();
          }
            return await _context.Matters.ToListAsync();
        }

        // GET: api/Matter/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Matter>> GetMatter(int id)
        {
          if (_context.Matters == null)
          {
              return NotFound();
          }
            var matter = await _context.Matters.FindAsync(id);

            if (matter == null)
            {
                return NotFound();
            }

            return matter;
        }

        // PUT: api/Matter/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMatter(int id, Matter matter)
        {
            if (id != matter.MatterId)
            {
                return BadRequest();
            }

            _context.Entry(matter).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MatterExists(id))
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

        // POST: api/Matter
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Matter>> PostMatter(Matter matter)
        {
          if (_context.Matters == null)
          {
              return Problem("Entity set 'MethodejDBContext.Matters'  is null.");
          }
            _context.Matters.Add(matter);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetMatter", new { id = matter.MatterId }, matter);
        }

        // DELETE: api/Matter/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMatter(int id)
        {
            if (_context.Matters == null)
            {
                return NotFound();
            }
            var matter = await _context.Matters.FindAsync(id);
            if (matter == null)
            {
                return NotFound();
            }

            _context.Matters.Remove(matter);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool MatterExists(int id)
        {
            return (_context.Matters?.Any(e => e.MatterId == id)).GetValueOrDefault();
        }
    }
}
