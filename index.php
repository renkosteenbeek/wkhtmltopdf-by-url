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
        $snappy = new Pdf('DISPLAY=:0 wkhtmltopdf');

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
        $footer = $this->getVar('footer', '/footers/' . getenv('defaultFooter'));
        if ($footer) {
            $snappy->setOption('footer-html', '/footers/' . $footer);
        }

        if ($this->getVar('template')) {
            $this->loadFromTemplate($this->getVar('template'), $snappy);
        }

        $snappy->setOption('use-xserver', true);

        $snappy->getOptions();
        $output = $snappy->getOutput($url);

        header('Content-Type: application/pdf');
        header('Content-Disposition: inline; filename="' . $title . '.pdf"');
        echo $output;
    }

    /**
     * Validate whether requested host is allowed
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

        throw new Exception("Requested host '" . $requestedHost . "' is not allowed", 1587321441);
    }

    /**
     * Load settings bases of template
     * @param $name
     * @param Pdf $snappy
     * @throws Exception
     */
    private function loadFromTemplate($name, $snappy)
    {
        if (!file_exists('/templates.json')) {
            throw new Exception("No template config does exists", 1592863261);
        }
        try {
            $config = json_decode(file_get_contents('/templates.json'));
        } catch (Exception $e) {
            return;
        }
        if (!$config->$name && $config->default) {
            $name = 'default';
        }
        if (!$config->$name) {
            throw new Exception("The requested template isn't available.", 1592863342);
        }

        foreach ($config->$name as $option) {
            $snappy->setOption($option->option, $option->value);
        }
    }

    /**
     * Get POST or GET var
     * @param string $name
     * @param string $default
     * @return string
     */
    private function getVar($name, $default = '')
    {
        if (isset($_POST[$name])) {
            return $_POST[$name];
        }
        if (isset($_GET[$name])) {
            return filter_var(urldecode($_GET[$name]), FILTER_SANITIZE_STRING);
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