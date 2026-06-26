using System;
using System.Collections.Generic;

namespace be.Entities
{
    public class User
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public ICollection<Todo> Todos { get; set; } = new List<Todo>();
    }
}