/*
 * Copyright 2015-2022 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.cloud.fn.consumer.tcp;

import org.junit.jupiter.api.Test;

import org.springframework.integration.ip.tcp.connection.TcpNetClientConnectionFactory;
import org.springframework.integration.test.util.TestUtils;
import org.springframework.test.context.TestPropertySource;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * @author Gary Russell
 */
@TestPropertySource(properties = {"tcp.consumer.host = foo"})
public class NotNioTests extends AbstractTcpConsumerTests {

	@Test
	public void test() throws Exception {
		assertThat(this.connectionFactory).isInstanceOf(TcpNetClientConnectionFactory.class);
		assertThat(this.connectionFactory.getHost()).isEqualTo("foo");
		assertThat(TestUtils.getPropertyValue(this.connectionFactory, "lookupHost", Boolean.class)).isFalse();
		assertThat(TestUtils.getPropertyValue(this.connectionFactory, "soTimeout")).isEqualTo(120000);
	}
}
