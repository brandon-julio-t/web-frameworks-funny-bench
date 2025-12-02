using FluentValidation;

var builder = WebApplication.CreateBuilder(args);

// Register FluentValidation
builder.Services.AddValidatorsFromAssemblyContaining<Program>();

var app = builder.Build();

app.MapPost("/", (Request request, IValidator<Request> validator) =>
{
    var validationResult = validator.Validate(request);
    if (!validationResult.IsValid)
    {
        return Results.BadRequest(new { error = "Invalid request body", errors = validationResult.Errors.Select(e => new { field = e.PropertyName, message = e.ErrorMessage }) });
    }
    
    return Results.Ok(new
    {
        data = $"Hello, \"{request.Name}\"!"
    });
});

var port = Environment.GetEnvironmentVariable("PORT") ?? "3000";
app.Run($"http://localhost:{port}");

public record Request
{
    public string Name { get; init; } = string.Empty;
}

public class RequestValidator : AbstractValidator<Request>
{
    public RequestValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Name is required")
            .MinimumLength(1).WithMessage("Name must be at least 1 character")
            .MaximumLength(100).WithMessage("Name must not exceed 100 characters");
    }
}
