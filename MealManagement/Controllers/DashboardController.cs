using Microsoft.AspNetCore.Mvc;

namespace MealManagement.Controllers
{
    public class DashboardController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
