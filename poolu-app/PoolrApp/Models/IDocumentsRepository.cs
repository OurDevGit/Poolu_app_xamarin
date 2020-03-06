using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PoolrApp.Models
{
    public interface IDocumentsRepository
    {
        Document GetDocument(int docId);

        void SaveDocument(Document doc);
    }
}
