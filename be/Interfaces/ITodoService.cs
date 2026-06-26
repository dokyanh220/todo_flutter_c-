using be.DTOs.Todo;

namespace be.Interfaces
{
    public interface ITodoService
    {
        Task<IEnumerable<TodoResponseDto>> GetAllAsync(int userId);
        Task<TodoResponseDto> CreateAsync(int userId, CreateTodoDto dto);
        Task<TodoResponseDto> UpdateAsync(int userId, int id, UpdateTodoDto dto);
        Task DeleteAsync(int userId, int id);
    }
}