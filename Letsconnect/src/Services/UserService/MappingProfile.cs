using AutoMapper;
using LetsConnect.Common.Models;
using UserService.Models.DTOs;

namespace UserService
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<User, UserProfileDTO>();
        }
    }
}
