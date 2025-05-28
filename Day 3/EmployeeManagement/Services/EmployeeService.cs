using EmployeeManagement.Models;
using System.Collections.Generic;
using System.Linq;

namespace EmployeeManagement.Services
{
    
    public class EmployeeService
    {
        private readonly List<Employee> _employees;

        public EmployeeService()
        {
            _employees = new List<Employee>
            {
                new Employee { Id = 1, Name = "Aryan", Department = "HR", Position = "Manager" },
                new Employee { Id = 2, Name = "Vyom", Department = "IT", Position = "Developer" }
            };
        }

        /// Retrieves all employees.
        public List<Employee> GetEmployees()
        {
            return _employees.ToList(); // return a copy to prevent external modification
        }

        /// Retrieves a single employee by their ID.
        public Employee GetEmployeeById(int id)
        {
            return _employees.FirstOrDefault(emp => emp.Id == id);
        }

        /// Adds a new employee.
        public void AddEmployee(Employee employee)
        {
            if (employee == null) return;

            // Assign a new unique ID
            employee.Id = _employees.Count > 0 ? _employees.Max(e => e.Id) + 1 : 1;
            _employees.Add(employee);
        }

        /// Updates an existing employee. Returns 1 if successful, -1 if not found.
        public int UpdateEmployee(Employee updatedEmployee)
        {
            if (updatedEmployee == null) return -1;

            var existingEmployee = GetEmployeeById(updatedEmployee.Id);
            if (existingEmployee == null) return -1;

            existingEmployee.Name = updatedEmployee.Name;
            existingEmployee.Department = updatedEmployee.Department;
            existingEmployee.Position = updatedEmployee.Position;

            return 1;
        }

        /// Deletes an employee by ID. Returns 1 if successful, -1 if not found.
        public int DeleteEmployee(int id)
        {
            var employeeToDelete = GetEmployeeById(id);
            if (employeeToDelete == null) return -1;

            _employees.Remove(employeeToDelete);
            return 1;
        }
    }
}
