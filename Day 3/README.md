# Employee Management System API

This is a simple ASP.NET Core Web API application for managing employee records. It supports basic CRUD (Create, Read, Update, Delete) operations using an in-memory list. This project is designed for learning and demonstration purposes.

## Features

- Get all employees
- Get a single employee by ID
- Add a new employee
- Update existing employee details
- Delete an employee by ID

## Technologies Used

- ASP.NET Core Web API (.NET 6+)
- C#
- Dependency Injection (Built-in)
- Swagger (Swashbuckle)

## Project Structure

- `Models/Employee.cs`: Defines the Employee data model.
- `Services/EmployeeService.cs`: Contains logic for CRUD operations.
- `Controllers/EmpController.cs`: API endpoints for employee management.
- `Program.cs`: Configures services and middleware.

## How to Run

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/employee-management-api.git
   cd employee-management-api
   ```

2. **Build and run the project**

   ```bash
   dotnet run
   ```

3. **Open in browser**

   Navigate to `https://localhost:{port}/swagger` to access the Swagger UI and test the API endpoints.

## API Endpoints

| Method | Route                      | Description                  |
|--------|----------------------------|------------------------------|
| GET    | `/api/Emp/GetAllEmployees` | Returns all employees        |
| GET    | `/api/Emp/{id}`            | Returns employee by ID       |
| POST   | `/api/Emp`                 | Adds a new employee          |
| PUT    | `/api/Emp`                 | Updates an existing employee |
| DELETE | `/api/Emp/{id}`            | Deletes employee by ID       |

## Sample Employee Model

```json
{
  "id": 0,
  "name": "John Doe",
  "department": "IT",
  "position": "Developer"
}
```

## Dependency Injection

Make sure `EmployeeService` is registered in `Program.cs`:

```csharp
builder.Services.AddSingleton<EmployeeService>();
```

## Notes

- This is an in-memory application. All data will reset when the application stops.
- For persistent storage, integrate with a database using Entity Framework Core.
