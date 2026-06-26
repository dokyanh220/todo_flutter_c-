using be.Data;
using be.DTOs.Todo;
using be.Entities;
using be.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace be.Services
{
    public class TodoService : ITodoService
    {
        private readonly AppDbContext _context;

        public TodoService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<TodoResponseDto>> GetAllAsync(int userId)
        {
            return await _context.Todos
                .Where(t => t.UserId == userId)
                .OrderByDescending(t => t.CreatedAt)
                .Select(t => new TodoResponseDto
                {
                   Id = t.Id,
                   Title = t.Title,
                   IsCompleted = t.IsCompleted,
                   CreatedAt = t.CreatedAt 
                }).ToListAsync();
        }

        public async Task<TodoResponseDto> CreateAsync(int userId, CreateTodoDto dto)
        {
            var todo = new Todo
            {
                UserId = userId,
                Title = dto.Title,
                IsCompleted = false
            };

            _context.Todos.Add(todo);
            await _context.SaveChangesAsync();

            return new TodoResponseDto { Id = todo.Id, Title = todo.Title, IsCompleted = todo.IsCompleted, CreatedAt = todo.CreatedAt};
        }

        public async Task<TodoResponseDto> UpdateAsync(int userId, int id, UpdateTodoDto dto)
        {
            var todo = await _context.Todos.SingleOrDefaultAsync(t => t.Id == id && t.UserId == userId);

            if (todo == null)
                throw new KeyNotFoundException("Không tìm thấy công việc");

            if (dto.Title != null) todo.Title = dto.Title;
            if (dto.IsCompleted.HasValue) todo.IsCompleted = dto.IsCompleted.Value;

            await _context.SaveChangesAsync();
            return new TodoResponseDto { Id = todo.Id, Title = todo.Title, IsCompleted = todo.IsCompleted, CreatedAt = todo.CreatedAt};
        }

        public async Task DeleteAsync(int userId, int id)
        {
            var todo = await _context.Todos.SingleOrDefaultAsync(t => t.Id == id && t.UserId == userId);

            if (todo == null)
                throw new KeyNotFoundException("Không tìm thấy công việc");

            _context.Todos.Remove(todo);
            await _context.SaveChangesAsync();
        }
    }
}