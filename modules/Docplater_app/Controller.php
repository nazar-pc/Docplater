<?php
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */

namespace cs\modules\Docplater_app;
use
	cs\Core,
	h;

class Controller {
	public static function editor () {
		return h::docplater_app();
	}
	/**
	 * @param \cs\Request  $Request
	 * @param \cs\Response $Response
	 */
	public static function download ($Request, $Response) {
		$context          = stream_context_create(
			[
				'http' => [
					'method'  => 'POST',
					'header'  => 'Content-Type: application/json',
					'content' => json_encode(
						[
							'contents' => base64_encode($Request->data('content'))
						]
					)
				]
			]
		);
		$stream           = fopen(Core::instance()->pdf_converter, 'rb', null, $context);
		$Response
			->header('content-type', 'application/pdf')
			->body_stream = $stream;
	}
}
