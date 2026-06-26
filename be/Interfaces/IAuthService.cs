using be.DTOs.Auth;

namespace be.Interfaces
{
    public class IAuthService
    {
        Task<bool> RegisterAsync(RegisterDto dto);
        Task<string> LoginAsync(string username, string password);
    }
}