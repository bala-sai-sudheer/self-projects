// src/BuildingBlocks/Common/Models/BaseEntity.cs
using System.ComponentModel.DataAnnotations;

namespace LetsConnect.Common.Models
{
    public abstract class BaseEntity
    {
        [Key]
        public Guid Id { get; set; } = Guid.NewGuid();
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
