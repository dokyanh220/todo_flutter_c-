using be.DTOs.Auth;

namespace be.Interfaces
{
    public interface IAuthService
    {
        Task<bool> RegisterAsync(RegisterDto dto);
        Task<AuthResponseDto> LoginAsync(string username, string password);
    }
}