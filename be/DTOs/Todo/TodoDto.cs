using System.ComponentModel.DataAnnotations;

namespace be.DTOs.Todo
{
    public class TodoResponseDto
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public bool IsCompleted { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }

    public class CreateTodoDto
    {
        [Required(ErrorMessage = "Tiều đề không được để trống")]
        [MaxLength(200, ErrorMessage = "Tiêu đề giới hạn 200 ký tự")]
        public string Title { get; set; } = string.Empty;
    }

    public class UpdateTodoDto
    {
        public string? Title { get; set; }
        public bool? IsCompleted { get; set; }
    }
}