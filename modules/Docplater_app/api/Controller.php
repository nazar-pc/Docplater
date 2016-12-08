<?php
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
namespace cs\modules\Docplater_app\api;
use
	cs\ExitException,
	cs\User,
	cs\modules\Docplater_app\Clause_template,
	cs\modules\Docplater_app\Document,
	cs\modules\Docplater_app\Document_template;

class Controller {
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function documents_get ($Request) {
		$id       = $Request->route_path(1);
		$Document = Document::instance();
		if ($id) {
			return static::prepare_type(
				static::objectize_clauses_instances($Document->get($id)),
				'document'
			);
		}
		return static::prepare_type(
			static::objectize_clauses_instances(
				$Document->get(
					$Document->search(
						[
							'user' => User::instance()->id
						]
					)
				)
			),
			'document'
		);
	}
	/**
	 * @param array[] $item
	 * @param string  $type
	 *
	 * @return array[]
	 */
	protected static function prepare_type ($item, $type) {
		if (!$item) {
			return $item;
		}
		if (is_array_indexed($item)) {
			foreach ($item as &$i) {
				$i['type'] = $type;
			}
		} else {
			$item['type'] = $type;
		}
		return $item;
	}
	/**
	 * @param array[] $document
	 *
	 * @return array[]
	 */
	protected static function objectize_clauses_instances ($document) {
		if (!$document) {
			return $document;
		}
		if (is_array_indexed($document)) {
			return array_map([static::class, 'objectize_clauses_instances'], $document);
		}
		foreach ($document['clauses'] as &$clause) {
			$clause['instances'] = (object)$clause['instances'];
		}
		return $document;
	}
	/**
	 * @param \cs\Request  $Request
	 * @param \cs\Response $Response
	 *
	 * @return string
	 *
	 * @throws \cs\ExitException
	 */
	public static function documents_post ($Request, $Response) {
		$data = $Request->data('title', 'content', 'parameters', 'clauses');
		if (!$data) {
			throw new ExitException(400);
		}
		$hash = Document::instance()->add(
			@$Request->data['group_uuid'] ?: [],
			@$Request->data['parent_hash'] ?: [],
			$data['title'],
			$data['content'],
			$data['parameters'],
			$data['clauses']
		);
		if (!$hash) {
			throw new ExitException(500);
		}
		$Response->code = 201;
		return $hash;
	}
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function templates_get ($Request) {
		$id                = $Request->route_path(1);
		$Document_template = Document_template::instance();
		if ($id) {
			return static::prepare_type(
				static::objectize_clauses_instances($Document_template->get($id)),
				'template'
			);
		}
		return static::prepare_type(
			static::objectize_clauses_instances(
				$Document_template->get(
					$Document_template->search()
				)
			),
			'template'
		);
	}
	/**
	 * @param \cs\Request  $Request
	 * @param \cs\Response $Response
	 *
	 * @return string
	 *
	 * @throws \cs\ExitException
	 */
	public static function templates_post ($Request, $Response) {
		$data = $Request->data('title', 'content', 'parameters', 'clauses');
		if (!$data) {
			throw new ExitException(400);
		}
		$hash = Document_template::instance()->add(
			@$Request->data['group_uuid'] ?: [],
			@$Request->data['parent_hash'] ?: [],
			$data['title'],
			$data['content'],
			$data['parameters'],
			$data['clauses']
		);
		if (!$hash) {
			throw new ExitException(500);
		}
		$Response->code = 201;
		return $hash;
	}
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function clauses_get ($Request) {
		$id              = $Request->route_path(1);
		$Clause_template = Clause_template::instance();
		if ($id) {
			return static::prepare_type(
				$Clause_template->get($id),
				'clause'
			);
		}
		return static::prepare_type(
			$Clause_template->get(
				$Clause_template->search()
			),
			'clause'
		);
	}
}
