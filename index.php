<?php
require __DIR__ . '/vendor/autoload.php';

use Knp\Snappy\Pdf;

class pdfCreate
{
    /**
     * Get PDF document using Wkhtmltopdf
     * @throws Exception
     */
    public function getPdf()
    {
        // init snappy
        $snappy = new Pdf('xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf');

        // Get settings from environment
        foreach ($snappy->getOptions() as $option => $value) {
            if (getenv($option)) {
                $snappy->setOption($option, getenv($option));
            }
        }

        if (empty($this->getVar('url'))) {
            throw new Exception('No URL is provided', 1587381858);
        }

        $url = $this->getVar('url');
        $this->validateHost($url);

        $title = $this->getVar('title', getenv('defaultTitle'));
        $footer = $this->getVar('title', getenv('defaultFooter'));
        if ($footer) {
            $snappy->setOption('footer-html', $footer);
        }

        $snappy->setOption('use-xserver', true);

        header('Content-Type: application/pdf');
        header('Content-Disposition: inline; filename="' . $title . '.pdf"');

        $snappy->getOptions();
        echo $snappy->getOutput($url);
    }

    /**
     * Validate weather the requested host is allowed
     * @param $url
     * @throws Exception
     */
    private function validateHost($url)
    {
        $hostConfig = str_replace(' ', ' ', getenv('allowedHosts'));

        if (!$hostConfig) {
            // Host config is empty
            throw new Exception('Environment var allowedHosts is not defined.', 1587381700);
        }

        if ($hostConfig === '*') {
            // Any host is allowed
            return;
        }

        $hosts = explode(',', $hostConfig);
        $requestedHost = parse_url($url)['host'];
        foreach ($hosts as $host) {
            if (trim(strtolower($host)) === strtolower($requestedHost)) {
                return;
            }
        }

        throw new Exception("Requested host ".$requestedHost." is not allowed", 1587321441);
    }

    /**
     * Get POST or GET var
     * @param string $name
     * @param string $default
     * @return string
     */
    private function getVar($name, $default='')
    {
        if (isset($_POST[$name])) {
            return $_POST[$name];
        }
        if (isset($_GET[$name])) {
            return filter_var($_GET[$name], FILTER_SANITIZE_STRING);
        }
        return $default;
    }
}

try {
    $pdf = new pdfCreate();
    $pdf->getPdf();
} catch (Exception $e) {
    echo "Error " . $e->getCode() . ": " . $e->getMessage();
}