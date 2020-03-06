using System;
using System.Collections.Generic;
using System.Web.Mvc;
using System.Configuration;
using Ninject;
using PoolrApp.Models;


namespace PoolrApp.Infrastructure
{
    public class NinjectDependencyResolver : IDependencyResolver
    {
        private IKernel kernel;

        public NinjectDependencyResolver(IKernel kernelParam)
        {
            kernel = kernelParam;
            AddBindings();
        }

        public object GetService(Type serviceType)
        {
            return kernel.TryGet(serviceType);
        }

        public IEnumerable<object> GetServices(Type serviceType)
        {
            return kernel.GetAll(serviceType);
        }

        private void AddBindings()
        {
            kernel.Bind<IDrawDatesRepository>().To<DrawDatesRepository>();

            kernel.Bind<ITicketsRepository>().To<TicketsRepository>();

            kernel.Bind<IPoolTypesRepository>().To<PoolTypesRepository>();

            kernel.Bind<IPoolsRepository>().To<PoolsRepository>();

            kernel.Bind<IAccountRepository>().To<AccountRepository>();

            kernel.Bind<IDocumentsRepository>().To<DocumentRepository>();

        }
    }
}