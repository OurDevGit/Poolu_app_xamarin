using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public class DocumentRepository : IDocumentsRepository
    {
        private AppDBContext context = new AppDBContext();

        public Document GetDocument(int docId) =>
            context.Documents.Where(d => d.DocId == docId).FirstOrDefault();

        public void SaveDocument(Document doc)
        {
            var dbEntry = context.Documents.Find(doc.DocId);
            if (dbEntry != null)
            {
                dbEntry.DocId = doc.DocId;
                dbEntry.DocContent =  doc.DocContent;
                context.SaveChanges();
            }

        }

        public void AddDocument(Document doc)
        {
            var dbEntry = context.Documents.Find(doc.DocId);
            if (dbEntry == null)
            {
                context.Documents.Add(doc);
                context.SaveChanges();
            }

        }

    }
}