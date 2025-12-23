using Microsoft.AspNetCore.Mvc;

namespace MealManagement.Controllers
{
    public class EntryController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
