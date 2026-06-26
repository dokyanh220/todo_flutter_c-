using System.ComponentModel.DataAnnotations;

namespace be.DTOs.Auth
{
    public class RegisterDto
    {
        [Required(ErrorMessage = "Tên đăng nhập không được để trống")]
        [MinLength(3, ErrorMessage = "Tên đăng nhập ít nhất 3 ký tự")]
        [MaxLength(50, ErrorMessage = "Tên đăng nhập không vượt quá 50 ký tự")]
        public string Username { get; set; } = string.Empty;

        [Required(ErrorMessage = "Mật khẩu không được để trống")]
        [MinLength(6, ErrorMessage ="Mật khẩu ít nhất 6 ký tự")]
        public string Password { get; set; } = string.Empty;
    }
}