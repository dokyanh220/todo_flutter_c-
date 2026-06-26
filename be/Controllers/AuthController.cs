using be.DTOs.Auth;
using be.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace be.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto dto)
        {
            try
            {
                await _authService.RegisterAsync(dto);
                return StatusCode(201, new { Message = "Đăng ký thành công" });
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { Messgae = ex.Message });
            }
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] RegisterDto dto)
        {
            try
            {
                var result = await _authService.LoginAsync(dto.Username, dto.Password);
                return Ok(new
                { 
                    Data = result,
                    Message = "Đăng mhập thành công" 
                });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Unauthorized(new { Messgae = ex.Message });
            }
        }

        [Authorize]
        [HttpPost("logout")]
        public IActionResult Logout()
        {
            return Ok(new { Message = "Đăng xuất thành công" });
        }
    }
}