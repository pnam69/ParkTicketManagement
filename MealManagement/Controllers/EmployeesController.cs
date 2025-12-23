using Microsoft.AspNetCore.Mvc;

namespace MealManagement.Controllers
{
    public class EmployeesController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
