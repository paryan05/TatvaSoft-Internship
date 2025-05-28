using EmployeeManagement.Models;
using EmployeeManagement.Services;
using Microsoft.AspNetCore.Mvc;

namespace EmployeeManagement.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmpController : ControllerBase
    {
        private readonly EmployeeService _employeeService;

        public EmpController(EmployeeService employeeService)
        {
            _employeeService = employeeService;
        }

        [HttpGet("GetAllEmployees")]
        public ActionResult<List<Employee>> GetAllEmployees()
        {
            var employees = _employeeService.GetEmployees();
            if (employees == null || employees.Count == 0)
                return NotFound("No employees found");

            return Ok(employees);
        }

        [HttpGet("{id}")]
        public ActionResult<Employee> GetEmployee(int id)
        {
            var emp = _employeeService.GetEmployeeById(id);
            if (emp == null)
                return NotFound("Employee not found");

            return Ok(emp);
        }

        [HttpPost]
        public ActionResult AddEmployee(Employee employee)
        {
            _employeeService.AddEmployee(employee);
            return Ok("Employee added successfully");
        }

        [HttpPut]
        public ActionResult UpdateEmployee(Employee employee)
        {
            var status = _employeeService.UpdateEmployee(employee);
            if (status == -1)
                return NotFound("Employee not found");

            return Ok("Employee updated successfully");
        }

        [HttpDelete("{id}")]
        public ActionResult DeleteEmployee(int id)
        {
            var status = _employeeService.DeleteEmployee(id);
            if (status == -1)
                return NotFound("Employee not found");

            return Ok("Employee deleted successfully");
        }
    }
}
