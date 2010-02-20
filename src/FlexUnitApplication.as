package
{

    import org.flexunit.runner.Request;

    import flash.display.Sprite;

    import flexunit.flexui.FlexUnitTestRunnerUIAS;
    import org.libspark.gunyarapaint.framework.test.TestSuite;
    public class FlexUnitApplication extends Sprite
    {

        public function FlexUnitApplication()
        {
            onCreationComplete();
        }

        private function onCreationComplete():void
        {
            var testRunner:FlexUnitTestRunnerUIAS=new FlexUnitTestRunnerUIAS();

            this.addChild(testRunner); 
            testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "framework");
        }
        public function currentRunTestSuite():Array
        {
            var testsToRun:Array = new Array();
            testsToRun.push(org.libspark.gunyarapaint.framework.test.TestSuite);
            return testsToRun;
        }
    }
}