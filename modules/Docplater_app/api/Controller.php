<?php
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
namespace cs\modules\Docplater_app\api;

class Controller {
	public static $clause_content = <<<HTML
<table>
	<tr><td>By:</td><td><docplater-document-parameter>by</docplater-document-parameter></td></tr>
	<tr><td>Name:</td><td><docplater-document-parameter>name</docplater-document-parameter></td></tr>
	<tr><td>Title:</td><td><docplater-document-parameter>title</docplater-document-parameter></td></tr>
	<tr><td>Date:</td><td><docplater-document-parameter>date</docplater-document-parameter></td></tr>
</table>
HTML;
	public static function documents () {
		$content = /** @lang HTML */
			<<<HTML
<h2 style="text-align: center;">NON-DISCLOSURE AGREEMENT</h2> 
<p>This Non-Disclosure Agreement (“Agreement”) is entered into on <docplater-document-parameter>date</docplater-document-parameter>, by and between <docplater-document-parameter>company_name</docplater-document-parameter> and <docplater-document-parameter>consultant_name</docplater-document-parameter> (“Consultant”).</p> 
<p>WHEREAS, Company (including its subsidiaries and affiliates) has developed or owns intellectual property (including, but not limited to, software, databases, data and systems), financial, technical, operational, marketing, administrative and/or business information, process and procedures that it deems confidential and/or proprietary, the unauthorized usage or disclosure of which could be detrimental to its business interests;</p> 
<p>NOW, THEREFORE, for good and valuable consideration, the sufficiency and receipt of which is hereby acknowledged, both parties agrees as follows:</p>
<ol>
	<li>As used herein, “Information” means intellectual property (including trade secrets, software and source code), Information or data existing and/or communicated in any form, including, but not limited to, oral, written, graphic, electronic, or electromagnetic forms, and “Proprietary Information” means (subject to Section 4(a), (b), (c), (d), and (e) below) that Information for which Company imposes restrictions regarding use and/or disclosure or which is clearly marked as confidential or, if disclosed orally, Consultant is provided notice at the time disclosed that such disclosure is confidential.</li> 
	<li>Consultant will treat Proprietary Information disclosed by Company as confidential and will safeguard it in the same manner that Consultant treats its own Proprietary Information of like kind, but will use no less than a reasonable degree of care. Consultant will only use such Proprietary Information solely in connection with the purposes for which it was disclosed hereunder, and will not disclose, distribute, or disseminate Proprietary Information in any way, to anyone except as provided in this Agreement. Upon discovery by Consultant of any unauthorized use or disclosure, said party shall notify Company and shall endeavor to prevent further unauthorized use or disclosure.</li> 
	<li>Consultant further agrees that: (I) only Consultant’s employees with a clear and defined need to know shall be granted access to Company’s Proprietary Information; (ii) Company’s Proprietary Information shall not be disclosed to any third parties without the prior written approval of Company; (iii) permitted disclosures to third parties shall be subject to all of the provisions of this Agreement; (iv) no copies shall be made of Company’s Proprietary Information (whether oral, written, graphic, electronic, or electromagnetic) without the prior written approval of Company; (v) all approved copies shall bear appropriate legends indicating that such information is Company’s Proprietary Information; and (vi) Consultant shall not make use of any of Company’s Proprietary Information for any purpose except that which is expressly contemplated by this Agreement and any consultancy agreement between the parties.</li> 
	<li>
		Proprietary Information of Company shall be treated as confidential and safeguarded by Consultant for a period of five (5) years after disclosure, unless Proprietary Information is:
		<ol>
			<li>generally available to the public, through no fault of Consultant or its employees and without breach of this Agreement; or</li>
			<li>already in the possession of Consultant without restriction and prior to any disclosure hereunder; or</li>
			<li>developed independently by employees of Consultant without breach of this Agreement; or</li>
			<li>approved in writing for release or disclosure without restriction by Company.</li>
		</ol>
	</li> 
	<li>Consultant specifically acknowledges and agrees that it may be exposed to Proprietary Information, whether Company's or a third party's, that Company did not intend to disclose and/or that Company did not intend to receive, merely as a result of Consultant’s contact with Company’s premises or employees. If, in the course and scope of its contact with Company, Consultant inadvertently receives any such Proprietary Information, Consultant will protect such Proprietary Information from any further disclosure and will not use such Proprietary Information in any way and will return such Information to Company immediately upon its discovery.</li> 
	<li>Consultant will maintain in force policies that require its employees to treat and maintain Company’s Proprietary Information in a confidential manner.</li> 
	<li>This Agreement shall remain in effect for two (2) years, except that the confidentiality obligations and all enforcement rights of Company shall survive any expiration or other termination of this Agreement.</li> 
	<li>Consultant will return to Company, or at Company’s request, destroy any and all Proprietary Information immediately upon Company’s written request, except for one copy may be retained by the Consultant’s legal department for the sole purpose of responding to any claims hereunder.</li> 
	<li>Except as specifically provided in this Agreement, neither party shall disclose the existence or the nature of the discussions between the parties relating to any Proprietary Information without the prior written authorization of the other party.</li> 
	<li>Each party acknowledges and agrees that a breach of this Agreement by Consultant will cause Company irreparable harm, and further acknowledges and agrees that Company is entitled to injunctive relief in any court of competent jurisdiction to prevent breach or to halt a further or continuing breach. Each party also acknowledges and agrees that such remedy is cumulative and in addition to any other remedy Company may have at law or in equity.</li> 
	<li>This Agreement and all obligations and rights arising hereunder shall be binding upon and inure to the benefit of the parties hereto and their respective successors and permitted assigns and its provisions may be modified, amended or waived only by written agreement of the parties.</li> 
	<li>This Agreement may be executed in two (2) or more counterparts, each of which, when executed, shall be considered an original for all purposes, provided that all counterparts shall, together, constitute one and the same document.</li> 
	<li>This Agreement shall be governed by and construed in accordance with the laws of the State of Delaware without regard to its choice of law rules.</li> 
</ol> 
<p>Both parties acknowledge that they have read this Agreement, understand it and agree to be bound by its terms and further agree that this Agreement is the complete and exclusive statement of the agreement between the parties with respect to the subject matter hereof, which supersedes all proposals, and all other communications, regardless of the form thereof, between the parties relating to the subject matter of this Agreement.</p> 
<p><strong>IN WITNESS WHEREOF</strong>, the undersigned have executed this Agreement as of the day first written above.</p> 
<p><strong><docplater-document-parameter>company_name</docplater-document-parameter> (Company)</strong> <strong><docplater-document-parameter>consultant_name</docplater-document-parameter> (Consultant)</strong></p> 
<table style="width: 100%">
	<tr>
		<td><docplater-document-clause hash="9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c" instance="0"></docplater-document-clause></td>
		<td><docplater-document-clause hash="9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c" instance="1"></docplater-document-clause></td>
	</tr>
</table>
HTML;

		$return                          = _json_decode(
		/** @lang JSON */
			<<<JSON
{
	"hash"       : "43cc23fa52b87b4cc1d02b5b114154151d6adddb17c9fddc06b027fa99e24008",
	"title"      : "NDA",
	"content"    : "",
	"parameters" : {
		"company_name"    : {
			"value"         : "Evil corporation",
			"default_value" : ""
		},
		"consultant_name" : {
			"value"         : "John Galt",
			"default_value" : ""
		},
		"date"            : {
			"value"         : "42 January 1984",
			"default_value" : ""
		}
	},
	"clauses"    : [
		{
			"hash"      : "9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c",
			"title"     : "Demo template",
			"content"   : "",
			"instances" : [
				{
					"by"    : {
						"value"         : "@company_name",
						"default_value" : ""
					},
					"name"  : {
						"value"         : "",
						"default_value" : ""
					},
					"title" : {
						"value"         : "",
						"default_value" : ""
					},
					"date"  : {
						"value"         : "",
						"default_value" : "@date"
					}
				},
				{
					"by"    : {
						"value"         : "@consultant_name",
						"default_value" : ""
					},
					"name"  : {
						"value"         : "",
						"default_value" : ""
					},
					"title" : {
						"value"         : "",
						"default_value" : ""
					},
					"date"  : {
						"value"         : "",
						"default_value" : "@date"
					}
				}
			]
		}
	]
}
JSON
		);
		$return['content']               = $content;
		$return['clauses'][0]['content'] = self::$clause_content;
		return $return;
	}
	public static function clauses () {
		return
			['content' => self::$clause_content] +
			_json_decode(
			/** @lang JSON */
				<<<JSON
	{
	"hash"       : "9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c",
	"title"      : "Demo template",
	"parameters" : [
		"by",
		"name",
		"title",
		"date"
	]
}
JSON
			);
	}
}
