using System.Web.Optimization;

namespace ClientFeatures {

    public class BundleConfig {

        public static void RegisterBundles(BundleCollection bundles) {

            bundles.Add(new StyleBundle("~/Content/css").Include(
                "~/Content/*.css"));

            BundleTable.EnableOptimizations = true;
        }
    }
}
