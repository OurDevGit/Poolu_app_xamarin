using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PoolrOCR
{
    public class Ticket
    {

        public Guid UserId { get; set; }


        public string PhotoName { get; set; }


        public int PhotoSize { get; set; }


        public DateTime UploadTime { get; set; }

        public int PoolId { get; set; }
    }
}
