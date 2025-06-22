using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using VeBookings.Models;
using Microsoft.Extensions.Hosting;
using System.Runtime.CompilerServices;

namespace VeBookings.Controllers
{
    public class EventController : Controller
    {
        private readonly ApplicationDbContext _context;
        public EventController(ApplicationDbContext context)
        {
            _context = context;
        }
        public async Task<IActionResult> Index(string searchType, int? venueId, DateTime? startDate, DateTime? endDate)

        {
            var events = _context.Event
                .Include(e => e.Venue)
                .Include(e => e.EventType)
                .AsQueryable();

            if(!string.IsNullOrEmpty(searchType) ) 
                events= events.Where(e =>e.EventType.Name == searchType);

            if (venueId.HasValue)
                events = events.Where(e => e.VenueId == venueId);

            if (startDate.HasValue && endDate.HasValue)
                events = events.Where(e => e.EventDate >= startDate && e.EventDate <= endDate);

            ViewData["EventTypes"] = _context.EventType.ToList();
            ViewData["Venues"] = _context.Venue.ToList();
            return View(await events.ToListAsync());
        }

        public IActionResult Create()
        {
            ViewData["Venues"] = _context.Venue.ToList();
            ViewData["EventTypes"] = _context.EventType.ToList();
            return View();

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Event @event)
        {
            if (ModelState.IsValid)
            {

                _context.Add(@event);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Evevt created successfully.";
                return RedirectToAction(nameof(Index));
            }

            ViewData["Venues"] = _context.Venue.ToList();

            ViewData["EventTypes"] = _context.EventType.ToList();
            return View(@event);
        }

        public async Task<IActionResult> Details(int? id)
        {

            var events = await _context.Event.FirstOrDefaultAsync(m => m.EventId == id);

            if (events == null)
            {
                return NotFound();
            }
            return View(events);
        }


        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null) return NotFound();

            var @event = await _context.Event
                .FirstOrDefaultAsync(e => e.EventId == id);

            if (@event == null) return NotFound();

            return View(@event);
        }
        //Perform Deletion(POST)
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]

        public async Task<IActionResult> DeleteConfirmed(int id) 
        {
            var @event = await _context.Event.FindAsync(id);
            if (@event == null) return NotFound();

            var isBooked = await _context.Booking.AnyAsync(b => b.EventId == id);
            if (isBooked)
            {
                TempData["ErrorMessage"] = "Cannot delete event because it has existing bookings.";
                return RedirectToAction(nameof(Index));
            }
            _context.Event.Remove(@event); 
            await _context.SaveChangesAsync();
            TempData["SuccessMessage"] = "Event deleted successfully.";
            return RedirectToAction(nameof(Index));
        }

        private bool CompanyExists(int id)
        {
            return _context.Event.Any(e => e.EventId == id);
        }
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var events = await _context.Event.FindAsync(id);
            if (id == null)
            {
                return NotFound();
            }
            ViewData["EventTypes"] = _context.EventType.ToList();
            return View(events);
        }
        [HttpPost]
        public async Task<IActionResult> Edit(int id, Event events)
        {
            if (id != events.EventId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(events);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!CompanyExists(events.EventId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }

            return View(events);
        }


    }
}
