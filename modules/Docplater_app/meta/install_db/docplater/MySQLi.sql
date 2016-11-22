CREATE TABLE `[prefix]docplater_clauses_templates` (
  `hash` char(40) NOT NULL COMMENT 'SHA-1(date + user + title + content + parameters)',
  `group_uuid` char(36) NOT NULL COMMENT 'UUID of the group to which this template clause belongs (is used to find related clauses)',
  `parent_hash` char(40) NOT NULL COMMENT 'Hash of the document on which current document was based',
  `date` bigint(20) NOT NULL,
  `user` int(10) UNSIGNED NOT NULL,
  `title` varchar(1024) NOT NULL,
  `content` text NOT NULL,
  `parameters` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `[prefix]docplater_documents` (
  `hash` char(40) NOT NULL COMMENT 'SHA-1(date + user + title + content + parameters + clauses)',
  `group_uuid` char(36) NOT NULL COMMENT 'UUID of the group to which this template document belongs (is used to find related documents)',
  `parent_hash` char(40) NOT NULL COMMENT 'Hash of the document on which current document was based',
  `date` bigint(20) NOT NULL,
  `user` int(10) UNSIGNED NOT NULL,
  `title` varchar(1024) NOT NULL,
  `content` text NOT NULL,
  `parameters` text NOT NULL,
  `clauses` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `[prefix]docplater_documents_templates` (
  `hash` char(40) NOT NULL COMMENT 'SHA-1(date + user + title + content + parameters + clauses)',
  `group_uuid` char(36) NOT NULL COMMENT 'UUID of the group to which this template document belongs (is used to find related documents)',
  `parent_hash` char(40) NOT NULL COMMENT 'Hash of the document on which current document was based',
  `date` bigint(20) NOT NULL,
  `user` int(10) UNSIGNED NOT NULL,
  `title` varchar(1024) NOT NULL,
  `content` text NOT NULL,
  `parameters` text NOT NULL,
  `clauses` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `[prefix]docplater_clauses_templates`
  ADD PRIMARY KEY (`hash`),
  ADD KEY `group_uuid` (`group_uuid`),
  ADD KEY `parent_hash` (`parent_hash`),
  ADD KEY `date` (`date`),
  ADD KEY `user` (`user`);

ALTER TABLE `[prefix]docplater_documents`
  ADD PRIMARY KEY (`hash`),
  ADD KEY `group_uuid` (`group_uuid`),
  ADD KEY `parent_hash` (`parent_hash`),
  ADD KEY `date` (`date`),
  ADD KEY `user` (`user`);

ALTER TABLE `[prefix]docplater_documents_templates`
  ADD PRIMARY KEY (`hash`),
  ADD KEY `group_uuid` (`group_uuid`),
  ADD KEY `parent_hash` (`parent_hash`),
  ADD KEY `date` (`date`),
  ADD KEY `user` (`user`);
