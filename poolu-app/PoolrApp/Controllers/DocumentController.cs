using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PoolrApp.Models;

namespace PoolrApp.Controllers
{
    [Authorize]
    public class DocumentController : Controller
    {
        private IDocumentsRepository repo;


        public DocumentController(IDocumentsRepository repository)
        {
           repo = repository;
        }

        public ActionResult List(int docId) => 
            View(repo.GetDocument(docId));

        [HttpPost]
        public ActionResult List(Document doc)
        {
            repo.SaveDocument(doc);

            return View("List", repo.GetDocument(doc.DocId));
        }

        [HttpPost]
        public ActionResult Add()
        {
            return View("Add", new Document());
        }

        [HttpPost]
        public ActionResult Add(Document doc)
        {
            repo.AddDocument(doc);

            return View("List", repo.GetDocument(doc.DocId));
        }

    }
}