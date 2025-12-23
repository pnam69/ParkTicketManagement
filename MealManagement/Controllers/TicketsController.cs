using Microsoft.AspNetCore.Mvc;

namespace MealManagement.Controllers
{
    public class TicketsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
