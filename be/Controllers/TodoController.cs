using System.Security.Claims;
using be.DTOs.Todo;
using be.Entities;
using be.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace be.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class TodoController : ControllerBase
    {
        private readonly ITodoService _todoService;

        public TodoController(ITodoService todoService)
        {
            _todoService = todoService;
        }

        private int GetUserId()
        {
            return int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var todos = await _todoService.GetAllAsync(GetUserId());
            return Ok(new { Data = todos });
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateTodoDto dto)
        {
            var todo = await _todoService.CreateAsync(GetUserId(), dto);
            return StatusCode(201, new { Message = "Thêm thành công", Data = todo });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdateTodoDto dto)
        {
            var todo = await _todoService.UpdateAsync(GetUserId(), id, dto);
            return Ok(new { Message = "Cập nhật thành công", Data = todo });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _todoService.DeleteAsync(GetUserId(), id);
            return Ok(new { Message = "Xóa thành công" });
        }
    }
}