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
    public class RevisionController : ControllerBase
    {
        private readonly MethodejDBContext _context;

        public RevisionController(MethodejDBContext context)
        {
            _context = context;
        }

        // GET: api/Revision
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Revision>>> GetRevisions()
        {
          if (_context.Revisions == null)
          {
              return NotFound();
          }
            return await _context.Revisions.ToListAsync();
        }

        // GET: api/Revision/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Revision>> GetRevision(int id)
        {
          if (_context.Revisions == null)
          {
              return NotFound();
          }
            var revision = await _context.Revisions.FindAsync(id);

            if (revision == null)
            {
                return NotFound();
            }

            return revision;
        }

        // PUT: api/Revision/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRevision(int id, Revision revision)
        {
            if (id != revision.RevisionId)
            {
                return BadRequest();
            }

            _context.Entry(revision).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RevisionExists(id))
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

        // POST: api/Revision
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Revision>> PostRevision(Revision revision)
        {
          if (_context.Revisions == null)
          {
              return Problem("Entity set 'MethodejDBContext.Revisions'  is null.");
          }
            _context.Revisions.Add(revision);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetRevision", new { id = revision.RevisionId }, revision);
        }

        // DELETE: api/Revision/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRevision(int id)
        {
            if (_context.Revisions == null)
            {
                return NotFound();
            }
            var revision = await _context.Revisions.FindAsync(id);
            if (revision == null)
            {
                return NotFound();
            }

            _context.Revisions.Remove(revision);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RevisionExists(int id)
        {
            return (_context.Revisions?.Any(e => e.RevisionId == id)).GetValueOrDefault();
        }
    }
}
